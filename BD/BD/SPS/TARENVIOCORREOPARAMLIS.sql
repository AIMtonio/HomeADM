-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOPARAMLIS`;
DELIMITER $$


CREATE PROCEDURE `TARENVIOCORREOPARAMLIS`(
	-- sp devuelve lista busqueda y grid
	Par_Descripcion			VARCHAR(200),			-- Descripcion
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de la lista a consultar

	Par_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID 			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	CHAR(1);			-- Declaracion de constante cadena vacia
	DECLARE		Fecha_Vacia		DATE;				-- Declaracion de constante fecha vacia
	DECLARE		Entero_Cero		INT(1);				-- Declaracion de constante entero cero
	DECLARE		Lis_Principal	INT(1);				-- Declaracion de constante de lista principal
	DECLARE 	Lis_grid		INT(11);			-- Declaracion de constante lista grid
	DECLARE		Estatus_A		CHAR(1);			-- Declaracion de constante estatus activo
	DECLARE		Estatus_B		CHAR(1);			-- Declaracion de constantes estatus baja
	DECLARE		TipoT			CHAR(1);			-- Declaracion de constante tipo T
	DECLARE		TipoS			CHAR(1);			-- Declaracion de constante tipo S
	DECLARE		TipoN			CHAR(1);			-- Declaracion de constante tipo N

	DECLARE		Tipo_N			VARCHAR(20);		-- Declaracion de constante tipo Ninguno
	DECLARE		Tipo_ST			VARCHAR(20);		-- Declaracion de constante tipo STRATTLS
	DECLARE		Tipo_S			VARCHAR(20);		-- Declaracion de constante tipo SSL
	DECLARE		Estatus_Ac		VARCHAR(20);		-- Declaracion de constante estatus Activo
	DECLARE		Estatus_Baj		VARCHAR(20);		-- Declaracion de constante estatus baja
	DECLARE 	Lis_usuariosCorr INT(1);			-- Declaracion de constante de lista usuarios correo

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Lis_Principal			:= 1;				-- Lista principal
	SET Lis_grid				:= 2;				-- Lista para grid.
	SET Lis_usuariosCorr		:= 3;				-- Lista  de correos de usuarios
	SET Estatus_A				:= 'A';				-- Estatus A
	SET Estatus_B				:= 'B';				-- Estatus B
	SET TipoT 					:= 'T';				-- Tipo T
	SET TipoS 					:= 'S';				-- Tipo S
	SET TipoN 					:= 'N';				-- Tipo N
	SET Tipo_N					:= 'Ninguno';		-- Tipo Ninguno
	SET Tipo_ST					:= 'STARTTLS';		-- Tipo STRATTLS
	SET Tipo_S					:= 'SSL';			-- Tipo SSL
	SET Estatus_Ac				:= 'ACTIVO';		-- Tipo ACTIVO
	SET Estatus_Baj				:= 'BAJA';			-- Tipo BAJA

	-- Lista principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT RemitenteID, 	Descripcion
			FROM TARENVIOCORREOPARAM
			WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			LIMIT 0, 15;
	END IF;

	-- Lista grid
	IF(Par_NumLis = Lis_grid) THEN
		SELECT 	RemitenteID, 		Descripcion,	ServidorSMTP,
				case when (TipoSeguridad = TipoT) THEN Tipo_ST
						WHEN (TipoSeguridad = TipoS) THEN Tipo_S
						WHEN (TipoSeguridad = TipoN) THEN Tipo_N
						END AS TipoSeguridad
					,	CorreoSalida,
				ConAutentificacion,	case when (Estatus = Estatus_A) THEN Estatus_Ac
						WHEN (Estatus = Estatus_B) THEN Estatus_Baj
						END AS Estatus
				FROM TARENVIOCORREOPARAM
				WHERE Estatus = Estatus_A
			ORDER BY RemitenteID DESC
		LIMIT 0,50;
	END IF;
	-- Listado de correos de usuarios destinatarios
	IF(Par_NumLis = Lis_usuariosCorr) THEN
		SELECT UsuarioID AS RemitenteID, Correo AS Descripcion
		FROM USUARIOS 
		WHERE Nombre LIKE CONCAT("%", Par_Descripcion, "%")
		AND IFNULL(Correo, Cadena_Vacia) <> Cadena_Vacia 
		AND Estatus = Estatus_A
		LIMIT 0, 15;
	END IF;


END TerminaStore$$
