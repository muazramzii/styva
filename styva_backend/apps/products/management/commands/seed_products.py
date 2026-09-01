import random
from decimal import Decimal

from django.core.management.base import BaseCommand
from django.utils.text import slugify

from apps.brands.models import Brand
from apps.categories.models import Category
from apps.products.models import Product, ProductVariant

BRANDS = [
    ('UNIQLO', 'UNQ'),
    ('Padini', 'PDN'),
    ('H&M', 'HNM'),
    ('Zara', 'ZRA'),
    ('Nike', 'NIK'),
    ('Adidas', 'ADS'),
]

CATEGORIES = ['Tops', 'Bottoms', 'Outerwear', 'Footwear']

SIZES = ['S', 'M', 'L', 'XL']

COLORS = ['Black', 'White', 'Grey', 'Navy', 'Beige']

TOTAL_PRODUCTS = 30


class Command(BaseCommand):
    help = 'Seed the catalog with placeholder brands, categories, products, and variants.'

    def handle(self, *args, **options):
        random.seed(42)

        brands = [
            Brand.objects.get_or_create(name=name, defaults={'slug': slugify(name)})[0]
            for name, _ in BRANDS
        ]
        codes = {name: code for name, code in BRANDS}

        categories = [
            Category.objects.get_or_create(name=name, defaults={'slug': slugify(name)})[0]
            for name in CATEGORIES
        ]

        created_count = 0
        for i in range(TOTAL_PRODUCTS):
            brand = brands[i % len(brands)]
            category = categories[i % len(categories)]
            code = codes[brand.name]
            sku = f'{code}{i + 1:03d}'
            color = random.choice(COLORS)
            price = Decimal(random.randrange(2990, 29990, 10)) / 100

            product, was_created = Product.objects.get_or_create(
                sku=sku,
                defaults={
                    'name': f'{brand.name} {category.name[:-1]} {color}',
                    'brand': brand,
                    'category': category,
                    'description': f'Placeholder {category.name.lower()} item from {brand.name}.',
                    'price': price,
                    'image': f'{sku}.png',
                },
            )
            if not was_created:
                continue

            created_count += 1
            ProductVariant.objects.bulk_create(
                ProductVariant(
                    product=product,
                    size=size,
                    color=color,
                    stock=random.randint(0, 50),
                )
                for size in SIZES
            )

        self.stdout.write(self.style.SUCCESS(
            f'Seeded {len(brands)} brands, {len(categories)} categories, '
            f'{created_count} new products (of {TOTAL_PRODUCTS} total).'
        ))
