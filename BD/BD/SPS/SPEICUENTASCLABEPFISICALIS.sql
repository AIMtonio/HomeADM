-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABEPFISICALIS`;
DELIMITER $$


CREATE PROCEDURE `SPEICUENTASCLABEPFISICALIS`(
# =================================================================
# -- SP PARA CONSULTAR LA INFORMACION DE CUENTAS CLABES --
# =================================================================
	Par_PIDTarea				VARCHAR(50),			-- ID de Proceso del Demonio
	Par_NumLis					TINYINT UNSIGNED,		-- Numero de Lista

	Aud_EmpresaID				INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,				-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				-- Cadena VAcia
	DECLARE	Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);				-- Entero Cero
	DECLARE Lis_PendEnvioDem		TINYINT;				-- Numero de consulta de firma
	DECLARE Est_Inactivo			CHAR(1);					-- Estatus Inactivo
	
	-- Asignacion de constantes
	SET	Cadena_Vacia				:= '';					-- Cadena VAcia
	SET	Fecha_Vacia					:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero					:= 0;					-- Entero Cero
	SET Lis_PendEnvioDem			:= 1;					-- Consulta de firma
	SET Est_Inactivo				:= 'I';					-- Estatus Inactivo

	-- Opcion 1 .- Lista de Cuentas clabes para la tarea de registro de cuentas clabes
	IF(Par_NumLis = Lis_PendEnvioDem) THEN
		SELECT 	CuentaClabePFisicaID,		ClienteID,					TipoInstrumento,				Instrumento,					CuentaClabe,
				FechaCreacion,				Estatus,					Nombre,							ApellidoPaterno,				ApellidoMaterno,
				EmpresaSTP,					RFC,						CURP,							EstadoID,						NumIntentos,			
				ClavePaisNacSTP,			Telefono,					Genero,							CorreoElectronico,				Identificacion,
				IF(RFC = Cadena_Vacia, CURP, RFC)  AS RfcCurp, 			
				DATE_FORMAT(IFNULL(FechaNacimiento, Fecha_Vacia), '%Y%m%d') as FechaNacimiento,
				EmpresaID,					Usuario,					DireccionIP,			Sucursal				
		FROM SPEICUENTASCLABEPFISICA
		WHERE PIDTarea = Par_PIDTarea AND Estatus = Est_Inactivo;
	END IF;
END TerminaStore$$ 
