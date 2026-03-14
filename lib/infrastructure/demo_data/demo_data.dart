import '../../domain/model/cake_category.dart';

final List<CakeCategory> cakeCategories = [
  /// TUG'ILGAN KUN TORTLARI
  CakeCategory(
    title: 'Tug‘ilgan kun tortlari',
    products: [
      const CakeCatalogItem(
        id: 'birthday_1',
        title: 'Pink Celebration',
        imageUrl:
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1200&q=80',
        description: 'Bayramlar uchun nafis pushti premium tort.',
        price: '320 000 so‘m',
        size: '2 kg',
        prepTime: '24 soat',
        serves: '10-14 kishi',
        likes: 234,
        featured: true,
      ),
      const CakeCatalogItem(
        id: 'birthday_2',
        title: 'Chocolate Party',
        imageUrl:
        'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=1200&q=80',
        description: 'Boy shokolad biskviti bilan premium tort.',
        price: '380 000 so‘m',
        size: '2.5 kg',
        prepTime: '24 soat',
        serves: '12-16 kishi',
        likes: 189,
      ),
      const CakeCatalogItem(
        id: 'birthday_3',
        title: 'Strawberry Dream',
        imageUrl:
        'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=1200&q=80',
        description: 'Qulupnayli yengil krem va yumshoq biskvit.',
        price: '350 000 so‘m',
        size: '2.2 kg',
        prepTime: '24 soat',
        serves: '10-12 kishi',
        likes: 150,
      ),
      const CakeCatalogItem(
        id: 'birthday_4',
        title: 'Golden Birthday Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?auto=format&fit=crop&w=1200&q=80',
        description: 'Oltin dekor bilan bezatilgan premium tort.',
        price: '420 000 so‘m',
        size: '3 kg',
        prepTime: '36 soat',
        serves: '15-18 kishi',
        likes: 201,
      ),
      const CakeCatalogItem(
        id: 'birthday_5',
        title: 'Minimal White Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1621303837174-89787a7d4729?auto=format&fit=crop&w=1200&q=80',
        description: 'Minimalistik dizayndagi zamonaviy tort.',
        price: '300 000 so‘m',
        size: '1.8 kg',
        prepTime: '20 soat',
        serves: '8-10 kishi',
        likes: 98,
      ),
    ],
  ),

  /// TO'Y TORTLARI
  CakeCategory(
    title: 'To‘y uchun maxsus tortlar',
    products: [
      const CakeCatalogItem(
        id: 'wedding_1',
        title: 'Wedding Classic',
        imageUrl:
        'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=1200&q=80',
        description: 'Ko‘p qavatli nafis to‘y torti.',
        price: '950 000 so‘m',
        size: '5 kg',
        prepTime: '48 soat',
        serves: '30-40 kishi',
        likes: 210,
        featured: true,
      ),
      const CakeCatalogItem(
        id: 'wedding_2',
        title: 'Elegant White Wedding',
        imageUrl:
        'https://images.unsplash.com/photo-1605478573537-99e56d2c9a6f?auto=format&fit=crop&w=1200&q=80',
        description: 'Oq rangli klassik to‘y torti.',
        price: '1 100 000 so‘m',
        size: '6 kg',
        prepTime: '48 soat',
        serves: '40-50 kishi',
        likes: 180,
      ),
      const CakeCatalogItem(
        id: 'wedding_3',
        title: 'Luxury Rose Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=1200&q=80',
        description: 'Atirgul dekor bilan bezatilgan hashamatli tort.',
        price: '1 250 000 so‘m',
        size: '7 kg',
        prepTime: '60 soat',
        serves: '45-60 kishi',
        likes: 240,
      ),
      const CakeCatalogItem(
        id: 'wedding_4',
        title: 'Royal Wedding Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=1200&q=80',
        description: 'Qirollik uslubidagi katta to‘y torti.',
        price: '1 500 000 so‘m',
        size: '8 kg',
        prepTime: '72 soat',
        serves: '60-80 kishi',
        likes: 300,
      ),
    ],
  ),

  /// BOLALAR TORTLARI
  CakeCategory(
    title: 'Bolalar uchun ertakona tortlar',
    products: [
      const CakeCatalogItem(
        id: 'kids_1',
        title: 'Rainbow Kids Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?auto=format&fit=crop&w=1200&q=80',
        description: 'Bolalar uchun rang-barang tort.',
        price: '410 000 so‘m',
        size: '2 kg',
        prepTime: '24 soat',
        serves: '10-12 kishi',
        likes: 305,
      ),
      const CakeCatalogItem(
        id: 'kids_2',
        title: 'Unicorn Fantasy',
        imageUrl:
        'https://images.unsplash.com/photo-1586788680434-30d324d9d46f?auto=format&fit=crop&w=1200&q=80',
        description: 'Unicorn dizaynidagi ertakona tort.',
        price: '460 000 so‘m',
        size: '2.5 kg',
        prepTime: '36 soat',
        serves: '12-16 kishi',
        likes: 210,
      ),
      const CakeCatalogItem(
        id: 'kids_3',
        title: 'Cartoon Party Cake',
        imageUrl:
        'https://images.unsplash.com/photo-1599785209796-786432b228bc?auto=format&fit=crop&w=1200&q=80',
        description: 'Multfilm qahramonlari bilan bezatilgan tort.',
        price: '440 000 so‘m',
        size: '2.3 kg',
        prepTime: '36 soat',
        serves: '12-14 kishi',
        likes: 190,
      ),
      const CakeCatalogItem(
        id: 'kids_4',
        title: 'Candy Explosion',
        imageUrl:
        'https://images.unsplash.com/photo-1607478900766-efe13248b125?auto=format&fit=crop&w=1200&q=80',
        description: 'Shirinliklar bilan to‘ldirilgan quvnoq tort.',
        price: '480 000 so‘m',
        size: '3 kg',
        prepTime: '36 soat',
        serves: '15-18 kishi',
        likes: 260,
      ),
    ],
  ),
];