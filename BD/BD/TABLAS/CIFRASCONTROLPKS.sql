-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIFRASCONTROLPKS
DELIMITER ;
DROP TABLE IF EXISTS CIFRASCONTROLPKS;
DELIMITER $$


CREATE TABLE CIFRASCONTROLPKS (
  NombreTabla varchar(30),
  FechaOperaciones datetime,
  NumRegistrosOriginal int,
  NumRegistrosRespaldo int,
  NumRegistrosActualizado int,
  PRIMARY KEY (NombreTabla)
)$$
