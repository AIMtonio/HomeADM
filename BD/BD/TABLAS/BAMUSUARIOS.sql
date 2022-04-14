-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOS
DELIMITER ;
DROP TABLE IF EXISTS `BAMUSUARIOS`;DELIMITER $$

CREATE TABLE `BAMUSUARIOS` (
  `UsuarioID` bigint(20) NOT NULL COMMENT 'Identificador del Usuario',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del Cliente',
  `Telefono` varchar(20) NOT NULL COMMENT 'Telefono Celular del Usuario',
  `Email` varchar(50) NOT NULL COMMENT 'Email del Usuario',
  `NIP` varchar(50) NOT NULL COMMENT 'NIP que sirve como contraseña para el acceso de la BM',
  `FechaUltimoAcceso` datetime NOT NULL COMMENT 'Fecha de Ultimo Acceso a la Banca Movil',
  `Estatus` char(1) NOT NULL COMMENT 'A .- Activo',
  `FechaCancelacion` datetime NOT NULL COMMENT 'Fecha de Cancelacion a la Banca Movil',
  `FechaBloqueo` datetime NOT NULL COMMENT 'Fecha de Bloqueo del Usuario',
  `MotivoBloqueo` varchar(200) NOT NULL COMMENT 'Motivo del Bloqueo del Usuario',
  `MotivoCancelacion` varchar(200) NOT NULL COMMENT 'Motivo de Cancelacion del Usuario',
  `FechaCreacion` date NOT NULL COMMENT 'Fecha de Registro',
  `RespuestaPregSecreta` varchar(100) NOT NULL COMMENT 'Respuesta de la Pregunta Secreta',
  `FraseBienvenida` varchar(45) NOT NULL COMMENT 'Frase de Bienvenida',
  `PerfilID` bigint(20) NOT NULL COMMENT 'Identificador del Perfil',
  `PreguntaSecretaID` bigint(20) NOT NULL COMMENT 'Identificador de la Pregunta Secreta',
  `ImagenAntPhisPerson` mediumblob NOT NULL COMMENT 'Imagen Antiphishing',
  `TokenID` bigint(20) NOT NULL COMMENT 'Identificador del Token',
  `ImagenLoginID` bigint(20) NOT NULL COMMENT 'Identificador de la Imagen Login',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`UsuarioID`),
  KEY `FK_BAMPERFILES_1` (`PerfilID`),
  KEY `FK_CLIENTES_2` (`ClienteID`),
  KEY `FK_BAMPREGSECRETAS_3` (`PreguntaSecretaID`),
  CONSTRAINT `FK_BAMPERFILES` FOREIGN KEY (`PerfilID`) REFERENCES `BAMPERFILES` (`PerfilID`) ON DELETE CASCADE,
  CONSTRAINT `FK_BAMPREGSECRETAS` FOREIGN KEY (`PreguntaSecretaID`) REFERENCES `BAMPREGSECRETAS` (`PreguntaSecretaID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Clientes que estan registrados en la Banca Movil'$$