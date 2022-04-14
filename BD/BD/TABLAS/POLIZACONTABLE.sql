-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `POLIZACONTABLE`;DELIMITER $$

CREATE TABLE `POLIZACONTABLE` (
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de Poliza',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nAfectacion',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de Poliza:\nManual  .- M\nAutomatica .- A\nProgramada .- P',
  `ConceptoID` int(11) DEFAULT NULL COMMENT 'Corresponde a algun ID de la tabla CONCEPTOSCONTA',
  `Concepto` varchar(150) NOT NULL COMMENT 'Concepto o \nDescripcion de la\nPoliza',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PolizaID`,`Fecha`),
  KEY `IDXFechaAplicacion` (`Fecha`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Poliza Contable'
/*!50100 PARTITION BY RANGE ( TO_DAYS(Fecha))
(PARTITION p0 VALUES LESS THAN (734868) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (734959) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (735050) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (735142) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */$$