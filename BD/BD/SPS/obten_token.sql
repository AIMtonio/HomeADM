-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- obten_token
DELIMITER ;
DROP PROCEDURE IF EXISTS `obten_token`;DELIMITER $$

CREATE PROCEDURE `obten_token`(numcontrato INTEGER,
numseccion INTEGER,OUT Clave varchar(15),INOUT posicion INTEGER	)
BEGIN
	declare temp_pos integer;
	set temp_pos=(Select LOCATE('@@',Clausulado,posicion) FROM `microfin`.`DetContrato` WHERE idContratos=numcontrato and idSecContrato=numseccion);
	set Clave=(select substring(Clausulado,temp_pos+2,LOCATE('@@',Clausulado,temp_pos+3)-temp_pos-2)
	FROM `microfin`.`DetContrato` WHERE idContratos=numcontrato and numseccion=idSecContrato);
	set posicion=temp_pos;
END$$