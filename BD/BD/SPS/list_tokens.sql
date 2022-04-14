-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- list_tokens
DELIMITER ;
DROP PROCEDURE IF EXISTS `list_tokens`;DELIMITER $$

CREATE PROCEDURE `list_tokens`(numcontrato int,numseccion int,OUT temp_text TEXT	)
BEGIN
DECLARE temp_clausulado TEXT;
set temp_clausulado="";
set @pos=1;
set @key1='';
set @longtotal=0;
set @valor='';
set @longtotal=(select length(Clausulado) FROM `microfin`.`DetContrato` WHERE idContratos=numcontrato and idSecContrato=numseccion);

WHILE @pos < @longtotal and @pos <> 0 DO
	set @pos_ini = @pos;
	call obten_token(1,1,@key1,@pos);
		if @pos <> 0 THEN
			set @valor=(select Valor from `microfin`.`DatosContratos`
				WHERE Clave=@Key1);
			set temp_clausulado = concat(temp_clausulado ,(select substring(Clausulado,@pos_ini,@pos-@pos_ini-1) from `microfin`.`DetContrato`
				WHERE idContratos=numcontrato and idSecContrato=numseccion),' ',@valor);

			set @pos = @pos + 4 + LENGTH(@key1);
		ELSE
			set temp_clausulado = concat(temp_clausulado ,(select substring(Clausulado,@pos_ini,@longtotal-@pos_ini) from `microfin`.`DetContrato`
				WHERE idContratos=numcontrato and idSecContrato=numseccion));
		END IF;
END WHILE;
set temp_text=temp_clausulado;
END$$