import secrets

from django.db import migrations, models

_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'


def backfill_existing_orders(apps, schema_editor):
    Order = apps.get_model('orders', 'Order')
    OrderItem = apps.get_model('orders', 'OrderItem')

    for order in Order.objects.filter(order_number__isnull=True):
        while True:
            suffix = ''.join(secrets.choice(_ALPHABET) for _ in range(6))
            number = f'STYVA-{order.created_at:%Y%m%d}-{suffix}'
            if not Order.objects.filter(order_number=number).exists():
                break
        order.order_number = number
        order.subtotal = order.total
        order.save(update_fields=['order_number', 'subtotal'])

    for item in OrderItem.objects.select_related('variant__product__brand'):
        item.product_name = item.variant.product.name
        item.brand_name = item.variant.product.brand.name
        item.size = item.variant.size
        item.color = item.variant.color
        item.subtotal = item.price * item.quantity
        item.save(update_fields=['product_name', 'brand_name', 'size', 'color', 'subtotal'])


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0002_initial'),
        ('products', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='order',
            options={'ordering': ['-created_at', '-id']},
        ),
        migrations.AlterModelOptions(
            name='orderitem',
            options={'ordering': ['id']},
        ),
        migrations.AddField(
            model_name='order',
            name='order_number',
            field=models.CharField(editable=False, max_length=32, null=True),
        ),
        migrations.AddField(
            model_name='order',
            name='payment_status',
            field=models.CharField(
                choices=[('pending', 'Pending'), ('success', 'Success'), ('failed', 'Failed')],
                default='pending', max_length=16,
            ),
        ),
        migrations.AddField(
            model_name='order',
            name='subtotal',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_fee',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_full_name',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_phone',
            field=models.CharField(default='', max_length=32),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_address_line_1',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_address_line_2',
            field=models.CharField(blank=True, default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_city',
            field=models.CharField(default='', max_length=128),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_state',
            field=models.CharField(default='', max_length=128),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='shipping_postcode',
            field=models.CharField(default='', max_length=16),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='order',
            name='updated_at',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='orderitem',
            name='product_name',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='orderitem',
            name='brand_name',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='orderitem',
            name='size',
            field=models.CharField(default='', max_length=32),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='orderitem',
            name='color',
            field=models.CharField(default='', max_length=64),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='orderitem',
            name='subtotal',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='orderitem',
            name='price',
            field=models.DecimalField(
                decimal_places=2, max_digits=10,
                help_text='Unit price snapshot at checkout time (exposed as unit_price in the API).',
            ),
        ),
        migrations.RunPython(backfill_existing_orders, migrations.RunPython.noop),
        migrations.AlterField(
            model_name='order',
            name='order_number',
            field=models.CharField(editable=False, max_length=32, unique=True),
        ),
    ]
