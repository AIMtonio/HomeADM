-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSRESERVCASTIG
DELIMITER ;
DROP TABLE IF EXISTS `PARAMSRESERVCASTIG`;DELIMITER $$

CREATE TABLE `PARAMSRESERVCASTIG` (
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `RegContaEPRC` char(1) DEFAULT NULL COMMENT 'Registro Contable EPRC: P.-  Cuenta Puente,  R.- Cuenta de Resultados',
  `EPRCIntMorato` char(1) DEFAULT NULL COMMENT 'Realizar Estimacion de Int.Moratorio: S .- Si, N .-No',
  `DivideEPRCCapitaInteres` char(1) DEFAULT NULL COMMENT 'Dividir EPRC de Capital e Interes: S.- Si, N .- No\\n',
  `CondonaIntereCarVen` char(1) DEFAULT NULL COMMENT 'Condonar Interes de Cartera Vencida: S.- Si, N.- No',
  `CondonaMoratoCarVen` char(1) DEFAULT NULL COMMENT 'Condonar Moratorios de Cartera Vencida: S.- Si, N .- No\\n',
  `CondonaAccesorios` char(1) DEFAULT NULL COMMENT 'Condonar Accesorios, Comisiones: S.- Si, N.- No\\n',
  `DivideCastigo` char(1) DEFAULT NULL COMMENT 'Indica si Divide el Castigo en :Capital, Interes, Moratorio. S .- Si, N.- No',
  `EPRCAdicional` char(1) DEFAULT NULL COMMENT 'Indica si Divide la EPRC por el Interes de Cartera Vencida',
  `IVARecuperacion` char(1) DEFAULT NULL COMMENT 'Especifica si cobrará IVA en Recuperacion S=SI, N= NO',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Numero de Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Nombre de Programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de Reservas y Castigos'$$