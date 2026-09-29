import secrets

import django.db.models.deletion
from django.db import migrations, models

_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'


def backfill_references(apps, schema_editor):
    Payment = apps.get_model('payment', 'Payment')
    for payment in Payment.objects.filter(reference__isnull=True):
        while True:
            reference = 'PAY-' + ''.join(secrets.choice(_ALPHABET) for _ in range(10))
            if not Payment.objects.filter(reference=reference).exists():
                break
        payment.reference = reference
        payment.save(update_fields=['reference'])


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0003_checkout_order_foundation'),
        ('payment', '0002_alter_payment_options'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='payment',
            options={'ordering': ['-created_at', '-id']},
        ),
        migrations.AlterField(
            model_name='payment',
            name='order',
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, related_name='payments', to='orders.order',
            ),
        ),
        migrations.AlterField(
            model_name='payment',
            name='method',
            field=models.CharField(blank=True, max_length=64),
        ),
        migrations.AddField(
            model_name='payment',
            name='provider',
            field=models.CharField(default='legacy', max_length=32),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='payment',
            name='provider_reference',
            field=models.CharField(blank=True, max_length=128, null=True),
        ),
        migrations.AddField(
            model_name='payment',
            name='updated_at',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='payment',
            name='reference',
            field=models.CharField(editable=False, max_length=32, null=True),
        ),
        migrations.RunPython(backfill_references, migrations.RunPython.noop),
        migrations.AlterField(
            model_name='payment',
            name='reference',
            field=models.CharField(editable=False, max_length=32, unique=True),
        ),
        migrations.AddConstraint(
            model_name='payment',
            constraint=models.UniqueConstraint(
                condition=models.Q(('payment_status', 'pending')),
                fields=('order',),
                name='one_pending_payment_per_order',
            ),
        ),
        migrations.AddConstraint(
            model_name='payment',
            constraint=models.UniqueConstraint(
                condition=models.Q(('payment_status', 'success')),
                fields=('order',),
                name='one_successful_payment_per_order',
            ),
        ),
        migrations.AddConstraint(
            model_name='payment',
            constraint=models.UniqueConstraint(
                condition=models.Q(('provider_reference__isnull', False)),
                fields=('provider', 'provider_reference'),
                name='unique_provider_reference',
            ),
        ),
        migrations.CreateModel(
            name='PaymentEvent',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('provider', models.CharField(max_length=32)),
                ('event_id', models.CharField(max_length=128)),
                ('status', models.CharField(
                    choices=[('pending', 'Pending'), ('success', 'Success'), ('failed', 'Failed')], max_length=16,
                )),
                ('outcome', models.CharField(
                    choices=[('applied', 'Applied'), ('ignored', 'Ignored')], max_length=16,
                )),
                ('payload', models.JSONField(blank=True, default=dict)),
                ('received_at', models.DateTimeField(auto_now_add=True)),
                ('payment', models.ForeignKey(
                    on_delete=django.db.models.deletion.CASCADE, related_name='events', to='payment.payment',
                )),
            ],
            options={
                'db_table': 'payment_events',
                'ordering': ['-received_at', '-id'],
                'constraints': [
                    models.UniqueConstraint(fields=('provider', 'event_id'), name='unique_provider_event'),
                ],
            },
        ),
    ]
