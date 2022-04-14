-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEILIS`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSSPEILIS`(
	-- STORE DE LISTA DE LOS PARAMETROS SPEI
	Par_EmpresaID			INT(11),			-- Numero de ID de empresa
	Par_Nombre				VARCHAR(100),		-- Valor por el cual se realizará la busqueda
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN

	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha vacia
	DECLARE Entero_Cero		INT;				-- Entero cero
	DECLARE Lis_Principal	INT;				-- Lista principal
	DECLARE Lis_Tesoreria	INT;				-- Lista para obtener las cuentas de Pasivo
	DECLARE Lis_Remitentes	INT(1); 			-- Lista de remitentes de correo

	SET Cadena_Vacia	:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia		:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Entero_Cero		:= 0;					-- Asignacion de entero cero
	SET Lis_Principal	:= 1;					-- Opcion principal
	SET Lis_Tesoreria	:= 2;					-- Opcion para obtener las cuentas de Pasivo
	SET Lis_Remitentes	:= 3;					-- Opcion para remitentes de correo

	-- Lista principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT PT.EmpresaID, INS.Nombre
			FROM PARAMETROSSPEI PS
				INNER JOIN PARAMETROSSIS PT ON PT.EmpresaID	=	PS.EmpresaID
				INNER JOIN INSTITUCIONES INS ON INS.InstitucionID	=	PT.InstitucionID
			WHERE	INS.Nombre LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

	-- Lista para obtener las cuentas de Pasivo
	IF(Par_NumLis = Lis_Tesoreria) THEN
		SELECT	CuentaCompleta, Descripcion
		FROM	CUENTASCONTABLES
		WHERE 	(CuentaCompleta LIKE CONCAT(Par_Nombre, "%") AND (CuentaCompleta LIKE '2%') )OR
				(Descripcion LIKE CONCAT("%", Par_Nombre, "%") AND (CuentaCompleta LIKE '2%'))
		LIMIT 0, 15;
		END IF;

	-- Lista para obtener los remitentes de correo
	IF(Par_NumLis = Lis_Remitentes) THEN
		SELECT RemitenteID,  CorreoSalida
			FROM TARENVIOCORREOPARAM
				WHERE	CorreoSalida LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

-- Fin de SP
END TerminaStore$$