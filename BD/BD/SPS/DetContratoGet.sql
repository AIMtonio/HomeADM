-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DetContratoGet
DELIMITER ;
DROP PROCEDURE IF EXISTS `DetContratoGet`;DELIMITER $$

CREATE PROCEDURE `DetContratoGet`(NumContrato INTEGER	)
BEGIN
DECLARE cur_seccion int;
DECLARE done INT DEFAULT 0;
DECLARE cur1 CURSOR FOR SELECT idSecContrato from DetConDatos where idSession=@identiunico;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
set @identiunico=(select UUID());
set @temp_text="";

insert into DetConDatos
Select @identiunico,`DetContrato`.`idContratos`, `DetContrato`.`idSecContrato`, `DetContrato`.`DescSecCont`, `DetContrato`.`Clausulado`
	from DetContrato WHERE idContratos=NumContrato;

OPEN cur1;

 REPEAT
    FETCH cur1 INTO cur_seccion;
	call list_tokens(NumContrato,cur_seccion,@temp_text);

	update DetConDatos set Clausulado=@temp_text
		where idSession=@identiunico and idContratos=NumContrato and idSecContrato=cur_seccion;
 UNTIL done END REPEAT;

select * from DetConDatos where idSession=@identiunico;
END$$