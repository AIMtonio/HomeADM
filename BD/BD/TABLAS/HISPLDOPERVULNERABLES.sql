-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPERVULNERABLES
DELIMITER ;
DROP TABLE IF EXISTS `HISPLDOPERVULNERABLES`;
DELIMITER $$


CREATE TABLE `HISPLDOPERVULNERABLES` (
  `Anio` int(11) NOT NULL COMMENT 'Anio de Reporte',
  `Mes` int(11) NOT NULL COMMENT 'Mes de reporte',
  `FechaReporto` date DEFAULT NULL COMMENT 'Fecha de reporte',
  `ClaveEntidadColegiada` varchar(20) DEFAULT NULL COMMENT 'Clave de la entidad de la financiera',
  `ClaveSujetoObligado` varchar(20) DEFAULT NULL COMMENT 'Clave del sujeto obligado de la financiera',
  `ClaveActividad` char(10) DEFAULT NULL COMMENT 'Clave de la actividad de la financiera',
  `Exento` int(11) DEFAULT NULL COMMENT 'Exento de la financiera',
  `DominioPlataforma` varchar(100) DEFAULT NULL COMMENT 'Dominio de la plataforma de la financiera',
  `ReferenciaAviso` int(11) DEFAULT NULL COMMENT 'Referencia del aviso',
  `Prioridad` int(11) DEFAULT NULL COMMENT 'Prioridad del aviso',
  `FolioModificacion` bigint(20) DEFAULT NULL COMMENT 'Folio de Modificacion',
  `DescripcionModificacion` varchar(3000) DEFAULT NULL COMMENT 'Descripcion de la modificacion',
  `TipoAlerta` int(11) DEFAULT NULL COMMENT 'Tipo d alerta',
  `DescripcionAlerta` varchar(3000) DEFAULT NULL COMMENT 'Descripcion alerta',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente a reportar',
  `CuentaRelacionada` varchar(100) DEFAULT NULL COMMENT 'Cuenta del cliente',
  `ClabeInterbancaria` varchar(25) DEFAULT NULL COMMENT 'Clabe interbancaria del cliente',
  `MonedaCuenta` int(11) DEFAULT NULL COMMENT 'Tipo de moneda de la cuenta principal del cliente',
  `NombrePF` varchar(100) DEFAULT NULL COMMENT 'Nombres del cliente persona fisica',
  `ApellidoPaternoPF` varchar(100) DEFAULT NULL COMMENT 'Apellido Paterno del cliente persona fisica',
  `ApellidoMaternoPF` varchar(100) DEFAULT NULL COMMENT 'Apellido Materno del cliente persona fisica',
  `FechaNacimientoPF` date DEFAULT NULL COMMENT 'Fecha de Nacimeinto del cliente persona fisica',
  `RFCPF` varchar(25) DEFAULT NULL COMMENT 'RFC del cliente persona fisica',
  `CURPPF` varchar(25) DEFAULT NULL COMMENT 'RFC del cliente persona fisica',
  `PaisNacionalidadPF` char(4) DEFAULT NULL COMMENT 'Pais Nacionalidad del Cliente Persona Fisica',
  `ActividadEconomicaPF` int(11) DEFAULT NULL COMMENT 'Actividad Economica de la Persona Fisica',
  `TipoIdentificacionPF` int(11) DEFAULT NULL COMMENT 'Tipo de identificaci??n de la Persona Fisica',
  `NumeroIdentificacionPF` varchar(30) DEFAULT NULL COMMENT 'Numero de Identificacion de la Persona Fisica',
  `DenominacionRazonPM` varchar(100) DEFAULT NULL COMMENT 'Denominaci??n o Raz??n Social de la Persona Moral',
  `FechaConstitucionPM` date DEFAULT NULL COMMENT 'Fecha de la Constitucion de la Persona Moral',
  `RFCPM` varchar(25) DEFAULT NULL COMMENT 'RFC de la persona Moral',
  `PaisNacionalidadPM` char(4) DEFAULT NULL COMMENT 'Pais Nacionalidad del Cliente Persona Moral',
  `GiroMercantilPM` int(11) DEFAULT NULL COMMENT 'N??mero de actividad econ??mica de la CNBV',
  `NombreRL` varchar(100) DEFAULT NULL COMMENT 'Nombre del Representante o Apoderado legal',
  `ApellidoPaternoRL` varchar(100) DEFAULT NULL COMMENT 'Apellido Paterno del Representante o Apoderado legal',
  `ApellidoMaternoRL` varchar(100) DEFAULT NULL COMMENT 'Apellido Materno del Representante o Apoderado legal',
  `FechaNacimientoRL` date DEFAULT NULL COMMENT 'Fecha de nacimiento del Representante o Apoderado legal',
  `RFCRL` varchar(25) DEFAULT NULL COMMENT 'RFC del Representante o Apoderado legal',
  `CURPRL` varchar(25) DEFAULT NULL COMMENT 'CURP del Representante o Apoderado legal',
  `TipoIdentificacionRL` int(11) DEFAULT NULL COMMENT 'Tipo de identificaci??n del Representante o Apoderado legal',
  `NumeroIdentificacionRL` varchar(30) DEFAULT NULL COMMENT 'Numero de Identificacion del Representante o Apoderado legal',
  `DenominacionRazonFedi` varchar(100) DEFAULT NULL COMMENT 'Denominacion del fedicomiso',
  `RFCFedi` varchar(25) DEFAULT NULL COMMENT 'RFC del fedicomiso',
  `FideicomisoIDFedi` int(11) DEFAULT NULL COMMENT 'ID del Fedicomiso',
  `NombreApo` varchar(100) DEFAULT NULL COMMENT 'Nombre del Apoderado del Fedicomiso',
  `ApellidoPaternoApo` varchar(100) DEFAULT NULL COMMENT 'Apellido Paterno del Apoderado del Fedicomiso',
  `ApellidoMaternoApo` varchar(100) DEFAULT NULL COMMENT 'Apellido Materno del Apoderado del Fedicomiso',
  `FechaNacimientoApo` date DEFAULT NULL COMMENT 'Fecha de nacimiento del Apoderado del Fedicomiso ',
  `RFCApo` varchar(25) DEFAULT NULL COMMENT 'RFC del Apoderado del Fedicomiso',
  `CURPApo` varchar(25) DEFAULT NULL COMMENT 'CURP del Apoderado del Fedicomiso',
  `TipoIdentificacionApo` int(11) DEFAULT NULL COMMENT 'Tipo de Didentificacion del Apoderado del Fedicomiso',
  `NumeroIdentificacionApo` varchar(30) DEFAULT NULL COMMENT 'numero de Identificacion del Apoderado del Fedicomiso',
  `ColoniaN` varchar(80) DEFAULT NULL COMMENT 'Colonia del cliente Nacional',
  `CalleN` varchar(80) DEFAULT NULL COMMENT 'Calle del cliente Nacional',
  `NumeroExteriorN` varchar(10) DEFAULT NULL COMMENT 'Numero Interior del cliente Nacional',
  `NumeroInteriorN` varchar(10) DEFAULT NULL COMMENT 'Numero Exterios del cliente Nacional',
  `CodigoPostalN` varchar(5) DEFAULT NULL COMMENT 'Numero exterios del cliente Nacional',
  `PaisE` varchar(30) DEFAULT NULL COMMENT 'Pais del cliente Extrangero',
  `EstadoProvinciaE` varchar(100) DEFAULT NULL COMMENT 'Estado y/o Provincia del cliente Extrangero',
  `CiudadPoblacionE` varchar(100) DEFAULT NULL COMMENT 'Ciudad del cliente Extrangero',
  `ColoniaE` varchar(100) DEFAULT NULL COMMENT 'Colonia del cliente Extrangero',
  `CalleE` varchar(100) DEFAULT NULL COMMENT 'Calle del cliente Extrangero',
  `NumeroExteriorE` varchar(10) DEFAULT NULL COMMENT 'Nuemero Exterior del cliente Extrangero',
  `NumeroInteriorE` varchar(10) DEFAULT NULL COMMENT 'Nuemero Interior del cliente Extrangero',
  `CodigoPostalE` varchar(10) DEFAULT NULL COMMENT 'Codigo Postal del cliente Extrangero',
  `ClavePaisPer` varchar(4) DEFAULT NULL COMMENT 'Clave Pais de la Persona Extrangera o Nacional',
  `NumeroTelefonoPer` varchar(25) DEFAULT NULL COMMENT 'Numero de telefono de la Persona Extrangera o Nacional',
  `CorreoElectronicoPer` varchar(50) DEFAULT NULL COMMENT 'Correo electronico de la Persona Extrangera o Nacional',
  `NombreDuePF` varchar(100) DEFAULT NULL COMMENT 'Nombre del beneficiario de la cuenta principal del cliente (relacionados a la cuenta) PF y PFA se consideran PF',
  `ApellidoPaternoDuePF` varchar(100) DEFAULT NULL COMMENT 'Apellido paterno del benificiario Cliente Persona Fisica',
  `ApellidoMaternoDuePF` varchar(100) DEFAULT NULL COMMENT 'Apellido materno del benificiario Cliente Persona Fisica',
  `FechaNacimientoDuePF` date DEFAULT NULL COMMENT 'Fecha de naciemiento del benificiario Cliente Persona Fisica',
  `RFCDuePF` varchar(25) DEFAULT NULL COMMENT 'RFC del benificiario Cliente Persona Fisica',
  `CURPDuePF` varchar(25) DEFAULT NULL COMMENT 'RFC del benificiario Cliente Persona Fisica',
  `PaisNacionalidadDuePF` varchar(4) DEFAULT NULL COMMENT 'Pais de nacionalidad del benificiario Cliente Persona Fisica',
  `DenominacionRazonDuePM` varchar(100) DEFAULT NULL COMMENT 'Denominacion del beneficiario Cliente Persona Moral',
  `FechaConstitucionDuePM` date DEFAULT NULL COMMENT 'Fecha de COnstitucion del beneficiario Cliente Persona Moral',
  `RFCDuePM` varchar(25) DEFAULT NULL COMMENT 'RFC del benificiario Cliente Persona Moral',
  `PaisNacionalidadDuePM` varchar(4) DEFAULT NULL COMMENT 'Pais de nacionalidad del benificiario Cliente Persona Moral',
  `DenominacionRazonDueFid` varchar(50) DEFAULT NULL COMMENT 'Fidecomiso del benificiario Cliente Persona Moral',
  `RFCDueFid` varchar(25) DEFAULT NULL COMMENT 'RFC del benificiario Cliente Persona Moral',
  `FideicomisoIDDueFid` int(11) DEFAULT NULL COMMENT 'ID del fidecomiso Cliente Persona Moral',
  `FechaHoraOperacionCom` date DEFAULT NULL COMMENT 'Fecha de la compra',
  `MonedaOperacionCom` int(11) DEFAULT NULL COMMENT 'Moneda de la compra',
  `MontoOperacionCom` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la compra',
  `ActivoVirtualOperadoAV` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de la compra',
  `DescripcionActivoVirtualAV` varchar(100) DEFAULT NULL COMMENT 'de la compra',
  `TipoCambioMnAV` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de la compra',
  `CantidadActivoVirtualAV` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de la compra',
  `HashOperacionAV` varchar(100) DEFAULT NULL COMMENT 'Hash de la operaci??n de compra',
  `FechaHoraOperacionV` date DEFAULT NULL COMMENT 'Fecha y hora en la que se concluy?? la venta',
  `MonedaOperacionV` int(11) DEFAULT NULL COMMENT 'Tipo de moneda de la operaci??n o acto de la venta',
  `MontoOperacionV` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la operaci??n o acto de la venta',
  `ActivoVirtualOperadoVAV` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de la venta',
  `DescripcionActivoVirtualVAV` varchar(100) DEFAULT NULL COMMENT 'Nombre del activo virtual si no est?? registrado en el cat??logo de la venta',
  `TipoCambioMnVAV` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de la venta',
  `CantidadActivoVirtualVAV` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de la venta',
  `HashOperacionVAV` varchar(100) DEFAULT NULL COMMENT 'Hash de la operaci??n de venta',
  `FechaHoraOperacionOI` date DEFAULT NULL COMMENT 'Fecha del intercambio',
  `ActivoVirtualOperadoOIAV` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de intercambio envio',
  `DescripcionActivoVirtualOIAV` varchar(100) DEFAULT NULL COMMENT 'Nombre del activo virtual si no est?? registrado en el cat??logo de intercambio envio',
  `TipoCambioMnOIAV` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de intercambio envio',
  `CantidadActivoVirtualOIAV` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de intercambio envio',
  `MontoOperacionMnOIAV` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la operaci??n o acto de intercambio envio',
  `ActivoVirtualOperadoOIAR` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de intercambio recibido',
  `DescripcionActivoVirtualOIAR` varchar(100) DEFAULT NULL COMMENT 'Nombre del activo virtual si no est?? registrado en el cat??logo de intercambio recibido',
  `TipoCambioMnOIAR` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de intercambio recibido',
  `CantidadActivoVirtualOIAR` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de intercambio recibido',
  `MontoOperacionMnOIAR` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la operaci??n o acto de intercambio recibido',
  `HashOperacionOIAR` varchar(100) DEFAULT NULL COMMENT 'Hash de la operaci??n de intercambio recibido',
  `FechaHoraOperacionOTE` date DEFAULT NULL COMMENT 'Fecha de la tranferencia enviadas',
  `MontoOperacionMnOTE` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la tranferencia enviadas',
  `ActivoVirtualOperadoOTAV` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de tranferencia de envio',
  `DescripcionActivoVirtualOTAV` varchar(100) DEFAULT NULL COMMENT 'Nombre del activo virtual si no est?? registrado en el cat??logo de tranferencia de envio',
  `TipoCambioMnOTAV` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de tranferencia de envio',
  `CantidadActivoVirtualOTAV` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de tranferencia de envio',
  `HashOperacionOTAV` varchar(100) DEFAULT NULL COMMENT 'Hash de la operaci??n de tranferencia de envio',
  `FechaHoraOperacionTR` date DEFAULT NULL COMMENT 'Fecha de la tranferencia recibidas',
  `MontoOperacionMnTR` decimal(16,2) DEFAULT NULL COMMENT 'Monto de la tranferencia recibidas',
  `ActivoVirtualOperadoTRA` int(11) DEFAULT NULL COMMENT 'Activo virtual operado de tranferencia recibida',
  `DescripcionActivoVirtualTRA` varchar(100) DEFAULT NULL COMMENT 'Nombre del activo virtual si no est?? registrado en el cat??logo de tranferencia recibida',
  `TipoCambioMnTRA` int(11) DEFAULT NULL COMMENT 'Tipo de cambio de tranferencia recibida',
  `CantidadActivoVirtualTRA` int(11) DEFAULT NULL COMMENT 'Cantidad del activo virtual de tranferencia recibida',
  `HashOperacionTRA` varchar(100) DEFAULT NULL COMMENT 'Hash de la operaci??n de tranferencia recibida',
  `FechaHoraOperacionFR` date DEFAULT NULL COMMENT 'Fecha de retiro de fondo',
  `InstrumentoMonetarioFR` int(11) DEFAULT NULL COMMENT 'Instrumento monetario que concluyo el retiro',
  `MonedaOperacionFR` int(11) DEFAULT NULL COMMENT 'Tipo de moneda de retiro',
  `MontoOperacionFR` decimal(16,2) DEFAULT NULL COMMENT 'Monto del retiro de fondos',
  `NombreFRPF` varchar(100) DEFAULT NULL COMMENT 'Nombre del beneficiario del retiro de fondo',
  `ApellidoPaternoFRPF` varchar(50) DEFAULT NULL COMMENT 'Apellido paterno del beneficiario del retiro de fondo',
  `ApellidoMaternoFRPF` varchar(50) DEFAULT NULL COMMENT 'Apellido materno del beneficiario del retiro de fondo',
  `DenominacionRazonFRPF` varchar(100) DEFAULT NULL COMMENT 'Denominaci??n o Raz??n Social del beneficiario del retiro de fondo',
  `ClabeDestinoFRN` varchar(30) DEFAULT NULL COMMENT 'Clabe interbancaria de destino',
  `ClaveInstitucionFinancieraFRN` varchar(20) DEFAULT NULL COMMENT 'Clave de la Instituci??n financiera',
  `NumeroCuentaFRE` varchar(100) DEFAULT NULL COMMENT 'Clabe interbancaria si la cuenta es exranjera',
  `NombreBancoFRE` varchar(100) DEFAULT NULL COMMENT 'Nombre del banco si la cuenta es exranjera',
  `FechaHoraOperacionFD` date DEFAULT NULL COMMENT 'Fecha de deposito al fondo',
  `InstrumentoMonetarioFD` int(11) DEFAULT NULL COMMENT 'Instrumento monetario que concluyo el deposito',
  `MonedaOperacionFD` int(11) DEFAULT NULL COMMENT 'Tipo de moneda de deposito',
  `MontoOperacionFD` decimal(16,2) DEFAULT NULL COMMENT 'Monto del depositos',
  `NombreFDPF` varchar(100) DEFAULT NULL COMMENT 'Nombre del beneficiario del deposito',
  `ApellidoPaternoFDPF` varchar(50) DEFAULT NULL COMMENT 'Apellido paterno del beneficiario del deposito',
  `ApellidoMaternoFDPF` varchar(50) DEFAULT NULL COMMENT 'Apellido materno del beneficiario del deposito',
  `DenominacionRazonFDPM` varchar(100) DEFAULT NULL COMMENT 'Denominaci??n o Raz??n Social del beneficiario del deposito',
  `ClabeDestinoFDN` varchar(30) DEFAULT NULL COMMENT 'Clabe interbancaria de destino',
  `ClaveInstitucionFinancieraFDN` varchar(20) DEFAULT NULL COMMENT 'Clave de la Instituci??n financiera',
  `NumeroCuentaFDE` varchar(100) DEFAULT NULL COMMENT 'Clabe interbancaria si la cuenta es exranjera',
  `NombreBancoFDE` varchar(100) DEFAULT NULL COMMENT 'Nombre del banco si la cuenta es exranjera',
  `Nacionalidad` char(2) DEFAULT NULL COMMENT 'Nacionalidad del cliente\n N.-NACIONAL \n E.-EXTRANJERO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`Anio`,`Mes`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Contiene los datos historicos de las operaciones vulnerables reportadas'$$
