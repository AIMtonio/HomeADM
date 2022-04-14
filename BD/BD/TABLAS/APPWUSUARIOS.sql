-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWUSUARIOS
DELIMITER ;
DROP TABLE IF EXISTS `APPWUSUARIOS`;
DELIMITER $$

CREATE TABLE `APPWUSUARIOS` (
  `UsuarioID` bigint(12) NOT NULL COMMENT 'Llave Primaria. ID del Usuario',
  `ClienteID` bigint(12) NOT NULL COMMENT 'contiene el ID del cliente en el core\n',
  `Contrasenia` varchar(200) NOT NULL COMMENT 'Indica la contrasenia del usuario',
  `PrimerNombre` varchar(200) NOT NULL COMMENT 'Indica el primero nombre del usuario',
  `SegundoNombre` varchar(200) NOT NULL COMMENT 'Indica el segundo nombre del usuario',
  `TercerNombre` varchar(200) NOT NULL COMMENT 'Indica el tercer nombre del usuario',
  `ApellidoPaterno` varchar(200) NOT NULL COMMENT 'Indica el apellido paterno del usuario',
  `ApellidoMaterno` varchar(200) NOT NULL COMMENT 'Indica el apellido materno del usuario',
  `NombreCompleto` varchar(300) NOT NULL COMMENT 'Nombre Completo del Usuario',
  `Curp` varchar(25) NOT NULL COMMENT 'Clave UNica de Registro Poblacinal',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Usuario\nA .- Activo\nB .- Bloqueado\nC .- Cancelado',
  `FechaCreacion` date NOT NULL COMMENT 'Fecha de Registro',
  `Correo` varchar(100) NOT NULL COMMENT 'Correo o Email',
  `TelefonoCelular` varchar(20) NOT NULL COMMENT 'Numero de Telefono Celular',
  `PrefijoTelefonico` varchar(20) NOT NULL COMMENT 'Prefijo Telefonico',
  `ImagenAntiphishingNumber` int(5) NOT NULL COMMENT 'Almacena el ID de la imagen Antiphishing del usuario',
  `FechaNacimiento` date NOT NULL COMMENT 'Fecha de nacimiento',
  `Tiene_NIP` char(1) NOT NULL COMMENT 'Estatus de asignacion de NIP \nValores\n1=No creado\n2=Creado para el wallet ',
  `DispositivoID` varchar(100) NOT NULL COMMENT 'Codigo de identificacion unico del telefono del usuario.',
  `FechaUltAcceso` date NOT NULL COMMENT 'Fecha de Ultimo Acceso para el wallet',
  `LoginsFallidos` int(11) NOT NULL COMMENT 'Numero de Logins Fallidos para el wallet',
  `EstatusSesion` char(1) NOT NULL COMMENT 'Estatus de sesion\nValores\nA=Activo\nI=Inactivo para el wallet',
  `FechaCancel` date NOT NULL COMMENT 'Fecha de Cancelacion para el wallet',
  `MotivoCancel` varchar(500) NOT NULL COMMENT 'Motivo por el cual se Cancela para el wallet',
  `FechaBloqueo` date NOT NULL COMMENT 'Fecha de Bloqueo del Usuario para el wallet',
  `MotivoBloqueo` varchar(500) NOT NULL COMMENT 'Motivo por el cual se Bloquea para el wallet',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`UsuarioID`),
  KEY `INDEX_TARUSUARIOS_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Usuario del wallet'$$