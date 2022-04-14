-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETCOBCARTERAASIG
DELIMITER ;
DROP TABLE IF EXISTS `DETCOBCARTERAASIG`;DELIMITER $$

CREATE TABLE `DETCOBCARTERAASIG` (
  `FolioAsigID` int(11) NOT NULL COMMENT 'ID de la tabla COBCARTERAASIG',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Credito asignado',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente',
  `EstatusCred` char(1) NOT NULL COMMENT 'Estatus Credito I = Inactivo A= Autorizado V= Vigente P = Pagado C = Cancelado B= Vencido K= Castigado',
  `DiasAtraso` int(11) NOT NULL COMMENT 'Dias de atraso que tiene el Credito ',
  `MontoCredito` decimal(12,2) NOT NULL COMMENT 'Monto otorgado del credito ',
  `FechaDesembolso` date NOT NULL COMMENT 'Fecha de desembolso ',
  `FechaVencimien` date NOT NULL COMMENT 'Fecha de vencimiento ',
  `SaldoCapital` decimal(16,2) NOT NULL COMMENT 'Saldo capital al dia de la asignacion',
  `SaldoInteres` decimal(16,2) NOT NULL COMMENT 'Saldo intereses al dia de la asignacion',
  `SaldoMoratorio` decimal(16,2) NOT NULL COMMENT 'Saldo moratorios al dia de la asignacion',
  `EstatusCredLib` char(1) NOT NULL COMMENT 'Estatus Credito al dia de la liberacion I = Inactivo A= Autorizado V= Vigente P = Pagado C = Cancelado B= Vencido K= Castigado',
  `DiasAtrasoLib` int(11) NOT NULL COMMENT 'Dias atraso al dia de la liberacion',
  `SaldoCapitalLib` decimal(16,2) NOT NULL COMMENT 'Saldo capital al dia de la liberacion',
  `SaldoInteresLib` decimal(16,2) NOT NULL COMMENT 'Saldo interes al dia de la liberacion',
  `SaldoMoratorioLib` decimal(16,2) NOT NULL COMMENT 'Saldo Moratorios al dia de la liberacion',
  `MotivoLiberacion` varchar(100) NOT NULL COMMENT 'Motivo de la liberacion',
  `CredAsignado` char(1) NOT NULL COMMENT 'Estatus del credito si esta asignado o no S=si y N=no',
  `NumAsig` int(11) NOT NULL COMMENT 'Numero de veces que se asigna el credito a un gestor de cobranza',
  `SucursalID` int(11) NOT NULL COMMENT 'ID sucursal origen del credito',
  `NombreCompleto` varchar(100) NOT NULL COMMENT 'Nombre completo del cliente',
  `FechaLibCred` date DEFAULT NULL COMMENT 'Fecha de liberacion del credito',
  `UsuarioLibCred` int(11) DEFAULT NULL COMMENT 'Usuario que libero el credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara detalles de Asignaciones de Cartera para Cobranza'$$