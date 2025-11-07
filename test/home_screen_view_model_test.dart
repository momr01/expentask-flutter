import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:payments_management/features/home/screens/home_screen.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/home/utils/filter_option.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';

import 'mockito.mocks.dart';

/*
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHomeServices mockHomeServices;
  late HomeScreenViewModel viewModel;

  // setUp(() {
  //   mockHomeServices = MockHomeServices();
  //   viewModel = HomeScreenViewModel();
  // });

  setUp(() {
  mockHomeServices = MockHomeServices();
  viewModel = HomeScreenViewModel(
    homeServices: mockHomeServices,
  );
});


/*
  test('fetchUndonePayments carga payments y foundPayments', () async {
    // final fakePayments = [
    //   // Payment(name: PaymentName(name: "Test Payment")),
    //   Payment(
    //       name: PaymentName(
    //           name: "test name",
    //           isActive: true,
    //           category: Category(name: "test category", isActive: true)),
    //       deadline: DateTime(2025),
    //       amount: 0,
    //       tasks: [],
    //       isActive: true,
    //       isCompleted: false,
    //       period: "08-2025",
    //       hasInstallments: false,
    //       installmentsQuantity: 0)
    // ];

    // when(mockHomeServices.fetchUndonePayments())
    //     .thenAnswer((_) async => fakePayments);

    // viewModel.fetchUndonePayments();

    // // await Future.delayed(const Duration(milliseconds: 100));

    // expect(viewModel.payments, fakePayments);
    // expect(viewModel.foundPayments, fakePayments);
    // expect(viewModel.isLoading, false);
    final fakePayments = [
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      )
    ];

    when(mockHomeServices.fetchUndonePayments())
        .thenAnswer((_) async => fakePayments);

    // Esperar a que termine el Future
    await viewModel.fetchUndonePayments();

    expect(viewModel.payments, fakePayments);
    expect(viewModel.foundPayments, fakePayments);
    expect(viewModel.isLoading, false);
  });

  // test('_runFilter filtra por nombre', () {
  // final payments = [
  // 	Payment(name: PaymentName(name: "Compra de Supermercado")),
  // 	Payment(name: PaymentName(name: "Pago de Luz")),
  // ];
  // viewModel.payments = payments;
  // viewModel.filterOptions = [
  // 	FilterOption(id: 1, name: "Todos", type: "all", state: true, filter: []),
  // 	FilterOption(id: 2, name: "Individual", type: "individual", state: false, filter: null),
  // ];

  // viewModel._runFilter("supermercado");

  // expect(viewModel.foundPayments.length, 1);
  // expect(viewModel.foundPayments.first.name.name, "Compra de Supermercado");
  // expect(viewModel.filterOptions.first.state, true);
  // });
}
*/

  test('fetchUndonePayments carga payments y foundPayments', () async {
    final fakePayments = [
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      )
    ];

    // when(() => mockHomeServices.fetchUndonePayments())
    //     .thenAnswer((_) async => fakePayments);
    when(() => mockHomeServices.fetchUndonePayments())
    .thenAnswer((_) async => fakePayments);


    await viewModel.fetchUndonePayments(); // AWAIT para asegurar que terminó

    expect(viewModel.payments, fakePayments);
    expect(viewModel.foundPayments, fakePayments);
    expect(viewModel.isLoading, false);
  });
}
*/
/*
void main() {
  late MockHomeServices mockHomeServices;
  late HomeScreenViewModel viewModel;

  setUp(() {
    mockHomeServices = MockHomeServices();
    //   viewModel = HomeScreenViewModel(homeServices: mockHomeServices);
  });

  test('fetchUndonePayments carga payments y foundPayments', () async {
    final fakePayments = [
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      )
    ];

    // Mockito con null-safety
    // when(() => mockHomeServices.fetchUndonePayments())
    //     .thenAnswer((_) async => fakePayments);
    // when(() => mockHomeServices.fetchUndonePayments())
    //     .thenReturn(Future.value(fakePayments));

    // await viewModel.fetchUndonePayments();

    // expect(viewModel.payments, fakePayments);
    // expect(viewModel.foundPayments, fakePayments);
    // expect(viewModel.isLoading, false);
  });
}
*/
/*
class MockHomeServices extends Mock implements HomeServices {}

void main() {
  late MockHomeServices mockHomeServices;
  late HomeScreenViewModel viewModel;

  setUp(() {
    mockHomeServices = MockHomeServices();
    viewModel = HomeScreenViewModel(homeServices: mockHomeServices);
  });

  test('fetchUndonePayments debe actualizar la lista de pagos con mock',
      () async {
    // Definí tus pagos falsos
    final fakePayments = <Payment>[
      // Payment(name: Name('Pago 1')),
      // Payment(name: Name('Pago 2')),

      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
    ];

    // Mockeá el método fetchUndonePayments para que retorne fakePayments
    when(mockHomeServices.fetchUndonePayments())
        .thenAnswer((_) async => fakePayments);

    // Llamá a fetchUndonePayments
    viewModel.fetchUndonePayments();

    // Verificá que la lista se actualizó
    expect(viewModel.payments, fakePayments);
    expect(viewModel.foundPayments, fakePayments);
    expect(viewModel.isLoading, false);

    // Verificá que el método mock fue llamado
    verify(mockHomeServices.fetchUndonePayments()).called(1);
  });
}*/

// Genera el mock automáticamente (creará home_services_test.mocks.dart)
@GenerateMocks([HomeServices])
void main() {
  late MockHomeServices mockHomeServices;
  late HomeScreenViewModel viewModel;

  setUp(() {
    mockHomeServices = MockHomeServices();
    viewModel = HomeScreenViewModel(homeServices: mockHomeServices);
  });

  test('fetchUndonePayments debe actualizar la lista de pagos', () async {
    final fakePayments = <Payment>[
      // Payment(name: Name('Pago 1')),
      // Payment(name: Name('Pago 2')),

      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
      Payment(
        name: PaymentName(
          name: "test name",
          isActive: true,
          category: Category(name: "test category", isActive: true),
        ),
        deadline: DateTime(2025),
        amount: 0,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
    ];

    when(mockHomeServices.fetchUndonePayments())
        .thenAnswer((_) async => fakePayments);

    await viewModel.fetchUndonePayments();

    expect(viewModel.payments, fakePayments);
    expect(viewModel.foundPayments, fakePayments);
    expect(viewModel.isLoading, false);

    verify(mockHomeServices.fetchUndonePayments()).called(1);
  });

  /* test('runFilter filtra correctamente los pagos y actualiza filtros', () {
    // Preparar datos fake
    final paymentsList = [
      Payment(
        name: PaymentName(
            name: "Pago uno",
            isActive: true,
            category: Category(name: "cat1", isActive: true)),
        deadline: DateTime(2025),
        amount: 100,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
      Payment(
        name: PaymentName(
            name: "Pago dos",
            isActive: true,
            category: Category(name: "cat2", isActive: true)),
        deadline: DateTime(2025),
        amount: 200,
        tasks: [],
        isActive: true,
        isCompleted: false,
        period: "08-2025",
        hasInstallments: false,
        installmentsQuantity: 0,
      ),
    ];

    // Inicializás el ViewModel con el mock para evitar llamadas reales
    viewModel.payments = paymentsList;
    viewModel.filterOptions = [
      FilterOption(
        id: 1,
        name: 'Todos',
        type: 'all',
        state: false,
        filter: (List<Payment> payments) =>
            payments.where((payment) => !payment.hasInstallments).toList(),
      ),
      FilterOption(
        id: 2,
        name: 'Activos',
        type: 'active',
        state: true,
        filter: (List<Payment> payments) =>
            payments.where((payment) => !payment.hasInstallments).toList(),
      ),
    ];

    // Ejecutás el filtro con keyword 'uno'
    viewModel.filter('uno');

    // Validás que sólo se encuentre el pago que contiene 'uno' en el nombre
    expect(viewModel.foundPayments.length, 1);
    expect(viewModel.foundPayments.first.name.name, contains('uno'));

    // Validás que el filtro tipo 'all' quedó activo y los otros no
    expect(
        viewModel.filterOptions.firstWhere((f) => f.type == 'all').state, true);
    expect(viewModel.filterOptions.firstWhere((f) => f.type != 'all').state,
        false);
  });*/
}
