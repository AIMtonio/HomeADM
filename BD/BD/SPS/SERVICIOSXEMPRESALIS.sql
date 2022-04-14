-- SP SERVICIOSXEMPRESALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSXEMPRESALIS;

DELIMITER $$
CREATE PROCEDURE SERVICIOSXEMPRESALIS(
	Par_ServicioID			INT(11),

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
	DECLARE EstatusSi	CHAR(1);
	DECLARE EstatusNo	CHAR(1);

	-- Asignación de constantes
	SET EstatusSi	:= 'S';
	SET EstatusNo	:= 'N';


	-- Comparación de las tablas para verificar cuál está seleccionado
	SELECT INO.InstitNominaID,
		INO.NombreInstit,
		CASE
			WHEN IFNULL(SEM.InstitNominaID,0) != 0 THEN
				EstatusSi
			ELSE
				EstatusNo
		END AS Estatus
	FROM INSTITNOMINA INO
	LEFT JOIN SERVICIOSXEMPRESA SEM ON INO.InstitNominaID = SEM.InstitNominaID
									AND SEM.ServicioID = Par_ServicioID;

END TerminaStore$$