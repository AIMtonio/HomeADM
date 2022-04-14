-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOC
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFICATIPDOC`;DELIMITER $$

CREATE TABLE `CLASIFICATIPDOC` (
  `ClasificaTipDocID` int(11) NOT NULL COMMENT 'Llave Principal para catalogo de Clasificacion de Documentos',
  `ClasificaDesc` varchar(50) NOT NULL COMMENT 'DescripciÃ³n de la ClasificaciÃ³n del documento',
  `ClasificaTipo` char(1) NOT NULL COMMENT 'Indica si la ClasificaciÃ³n Pertenece a Checklist de Solicitudes o si pertenece  Mesa de Control\nS = Solicitud\nM = Mesa de Control',
  `TipoGrupInd` char(1) NOT NULL COMMENT 'Campo que indica si la clasificacion es requerida en Solicitudes o Creditos Grupales Individuales o en Ambas\nI = Individual\nG = Grupal\nA = Ambos',
  `GrupoAplica` int(11) NOT NULL COMMENT 'Indica si la Clasificacion sera requerida a un integrante en particular, o a todos los integrantes\n0 = No Aplica o No se Usa\n1 = Presidente\n2 = Tesorero\n3 = Secretario\n4 = Integrante\n5 =Todos\n',
  `EsGarantia` char(1) NOT NULL COMMENT 'Indica Si la Clasificacion es de Garantia que se debe encontrar en la Solicitud de Credito\nS = Si\nN = No',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`ClasificaTipDocID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Clasificacion de Documentos para CheckList'$$