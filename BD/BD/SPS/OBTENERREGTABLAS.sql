-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBTENERREGTABLAS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBTENERREGTABLAS`;DELIMITER $$

CREATE PROCEDURE `OBTENERREGTABLAS`(
	Par_NombreBD VARCHAR (50)
)
TerminaStore: BEGIN

/* Variables */
 DECLARE Var_Sentencia	MEDIUMTEXT;

	SET SESSION group_concat_max_len = 1000000;

    /*-------------------------------------*/
            SELECT
				GROUP_CONCAT(
					CONCAT (
					'SELECT ''',TABLE_NAME,''' as TableName, COUNT(*) as RowCount, ''',TABLE_COMMENT,''' as Descripcion FROM ',

						Par_NombreBD,'.','`',TABLE_NAME,'`',' ', CHAR(10))
						SEPARATOR 'UNION '
							) INTO Var_Sentencia
					FROM
						information_schema.`TABLES` AS t
						WHERE
						t.TABLE_SCHEMA = Par_NombreBD AND
						t.TABLE_TYPE = "BASE TABLE"
						ORDER BY
					t.TABLE_NAME ASC;
	/*--------------------------------------*/

	SET @Sentencia	= (Var_Sentencia);

	PREPARE STREP FROM @Sentencia;
	EXECUTE STREP;

	DEALLOCATE PREPARE STREP;

END TerminaStore$$