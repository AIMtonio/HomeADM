-- SP SERVICIOSADICIONALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSADICIONALESLIS;

DELIMITER $$
CREATE PROCEDURE SERVICIOSADICIONALESLIS(
	Par_ServicioID			INT(11),
	Par_Descripcion			VARCHAR(1000),
	Par_ProducCreditoID		INT(11),
	Par_InstitNominaID		INT(11),
	Par_NumLis				TINYINT UNSIGNED,			--	NÚMERO DE LISTA.

	Aud_EmpresaID			INT(11),					--	Parámetro de auditoría
	Aud_Usuario				INT(11),					--	Parámetro de auditoría
	Aud_FechaActual			DATETIME,					--	Parámetro de auditoría
	Aud_DireccionIP			VARCHAR(15),				--	Parámetro de auditoría
	Aud_ProgramaID			VARCHAR(50),				--	Parámetro de auditoría
	Aud_Sucursal			INT(11),					--	Parámetro de auditoría
	Aud_NumTransaccion		BIGINT(20)					--	Parámetro de auditoría
)
TerminaStore : BEGIN
	-- Declaración de constantes
	DECLARE List_Uno		INT;						-- Lista Principal
	DECLARE List_Dos		INT;						-- Lista Institucion Nomina
	DECLARE List_Tres		INT;						-- Lista por una Lista de Productos
	DECLARE Con_Estatus		CHAR(1);					-- Constante para indicar el estatus en ACTIVO
	DECLARE Entero_Cero     INT;


	DECLARE Var_Sentencia	 VARCHAR(2000);

	-- Asignacion de constantes
	SET List_Uno				:=1;					--	Lista principal
	SET List_Dos				:=2;					--	Lista para obtener las solicitud por producto/empresa
	SET List_Tres				:=3;					--	Lista para obtener las instituciones de nomina ligadas a los productos
	SET Con_Estatus				:= 'A';					--	Constante para indicar el estatus en ACTIVO
	SET Entero_Cero 			:= 0;					-- Entero Cero
	-- Asignacion de Variables
	SET Var_Sentencia 			:= '';							-- Variable para el prepare dimanico de la lista 3

	IF (List_Uno = Par_NumLis) THEN
		SELECT ServicioID,	Descripcion
		  FROM SERVICIOSADICIONALES
		 WHERE Estatus = Con_Estatus
		   AND Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 15;
	END IF;

	IF (List_Dos = Par_NumLis) THEN
		IF Par_ProducCreditoID != 0 AND Par_InstitNominaID != 0 THEN
				SELECT Ser.ServicioID, Ser.Descripcion, Ser.ValidaDocs, Ser.TipoDocumento,	SeP.ProducCreditoID,
					IFNULL(SeE.InstitNominaID,0) AS InstitNominaID
				FROM SERVICIOSADICIONALES Ser
				INNER JOIN SERVICIOSXPRODUCTO SeP ON Ser.ServicioID = SeP.ServicioID
				LEFT JOIN SERVICIOSXEMPRESA SeE  ON Ser.ServicioID 	= SeE.ServicioID
				WHERE SeP.ProducCreditoID = Par_ProducCreditoID
				  AND SeE.InstitNominaID = Par_InstitNominaID
				  AND Ser.Estatus = Con_Estatus
				LIMIT 15;
		ELSEIF Par_ProducCreditoID != 0 AND Par_InstitNominaID = 0 THEN
				SELECT Ser.ServicioID, Ser.Descripcion, Ser.ValidaDocs, Ser.TipoDocumento,	SeP.ProducCreditoID,
					IFNULL(SeE.InstitNominaID,0) AS InstitNominaID
				FROM SERVICIOSADICIONALES Ser
				INNER JOIN SERVICIOSXPRODUCTO SeP ON Ser.ServicioID = SeP.ServicioID
				LEFT JOIN SERVICIOSXEMPRESA SeE  ON Ser.ServicioID 	= SeE.ServicioID
				WHERE SeP.ProducCreditoID = Par_ProducCreditoID
				  AND Ser.Estatus = Con_Estatus
				LIMIT 15;
		ELSEIF Par_ProducCreditoID = 0 AND Par_InstitNominaID != 0 THEN
				SELECT Ser.ServicioID, Ser.Descripcion, Ser.ValidaDocs, Ser.TipoDocumento,	SeP.ProducCreditoID,
					IFNULL(SeE.InstitNominaID,0) AS InstitNominaID
				FROM SERVICIOSADICIONALES Ser
				INNER JOIN SERVICIOSXPRODUCTO SeP ON Ser.ServicioID = SeP.ServicioID
				LEFT JOIN SERVICIOSXEMPRESA SeE  ON Ser.ServicioID 	= SeE.ServicioID
				WHERE SeE.InstitNominaID = Par_InstitNominaID
				  AND Ser.Estatus = Con_Estatus
				LIMIT 15;
		END IF;
	END IF;

	IF (List_Tres = Par_NumLis) THEN

		SET Var_Sentencia := 'SELECT DISTINCT Ins.InstitNominaID, CONCAT(Ins.InstitNominaID, '' '',Ins.NombreInstit) AS NombreInstit
									FROM INSTITNOMINA Ins INNER JOIN NOMCONDICIONCRED NPro
									ON NPro.InstitNominaID = Ins.InstitNominaID
									AND Ins.Estatus = \'A\'
								WHERE NPro.ProducCreditoID IN (';
		SET Var_Sentencia := CONCAT(Var_Sentencia,Par_Descripcion,')');

		SET @Sentencia    := (Var_Sentencia);
		PREPARE EjecutaConInt FROM @Sentencia;
		EXECUTE  EjecutaConInt;
		DEALLOCATE PREPARE EjecutaConInt;

	END IF;
END TerminaStore$$
