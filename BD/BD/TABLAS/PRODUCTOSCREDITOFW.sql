-- PRODUCTOSCREDITOFW

DELIMITER ;

DROP TABLE IF EXISTS `PRODUCTOSCREDITOFW`;

DELIMITER $$

CREATE TABLE `PRODUCTOSCREDITOFW` (
  `ProductoCreditoFWID`   INT(11)             NOT NULL          COMMENT 'Llave primaria de la tabla',
  `ProductoCreditoID`     INT(11)             NOT NULL          COMMENT 'Llave foranea de la tabla PRODUCTOSCREDITO',
  `DestinoCreditoID`      INT(11)             NOT NULL          COMMENT 'Llave foranea de la tabla DESTINOSCREDITO',
  `ClasificacionDestino`  CHAR(1)             NOT NULL          COMMENT 'Clasificacion del Destino Credito',
  `PerfilID`              INT(11)             NOT NULL          COMMENT 'ID del d perfil de Banca en Linea',
  `EmpresaID`             INT(11)             NOT NULL          COMMENT 'Campo de auditoria',
  `Usuario`               INT(11)             NOT NULL          COMMENT 'Campo de auditoria',
  `FechaActual`           DATETIME            NOT NULL          COMMENT 'Campo de auditoria',
  `DireccionIP`           VARCHAR(15)         NOT NULL          COMMENT 'Campo de auditoria',
  `ProgramaID`            VARCHAR(50)         NOT NULL          COMMENT 'Campo de auditoria',
  `Sucursal`              INT(11)             NOT NULL          COMMENT 'Campo de auditoria',
  `NumTransaccion`        BIGINT(20)          NOT NULL          COMMENT 'Campo de auditoria',
  PRIMARY KEY (ProductoCreditoFWID),
  KEY `fk_PRODUCTOSCREDITOFW_1_idx` (`ProductoCreditoID`),
  KEY `fk_PRODUCTOSCREDITOFW_2_idx` (`DestinoCreditoID`),
  CONSTRAINT `fk_PRODUCTOSCREDITOFW_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCTOSCREDITOFW_2` FOREIGN KEY (`DestinoCreditoID`) REFERENCES `DESTINOSCREDITO` (`DestinoCreID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
