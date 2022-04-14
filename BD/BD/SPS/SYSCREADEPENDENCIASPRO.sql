-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SYSCREADEPENDENCIASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SYSCREADEPENDENCIASPRO`;DELIMITER $$

CREATE PROCEDURE `SYSCREADEPENDENCIASPRO`(Tabla varchar(30)	)
TerminaStore: BEGIN

DECLARE Var_Tabla varchar(30);
DECLARE Var_Contador int;
DECLARE Var_Sentencia   varchar(3000);

DECLARE cur_tablas cursor for
    select  TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='microfin'
	union
	select ROUTINE_NAME as TABLE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA='microfin' ;

SET Var_Contador=0;

 Open  cur_tablas;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    Loop
                        Fetch cur_tablas  Into 	Var_Tabla;
                        Set Var_Contador    := Var_Contador + 1;

					set @Var_Senten= CONCAT('
					insert into SYSDEPENDENCIAS
					Select',' ''',trim(Var_Tabla),''' ,ROUTINE_NAME,substring(ROUTINE_TYPE,1,1),'' '',''SYS'',NOW()
							FROM  INFORMATION_SCHEMA.ROUTINES
							WHERE ROUTINE_SCHEMA=''microfin'' and ROUTINE_DEFINITION like ''%',trim(Var_Tabla),'%',''';');


					PREPARE SP FROM @Var_Senten;
					EXECUTE SP;
					DEALLOCATE PREPARE SP;

                    End Loop;
                END;
        Close cur_tablas;


END TerminaStore$$