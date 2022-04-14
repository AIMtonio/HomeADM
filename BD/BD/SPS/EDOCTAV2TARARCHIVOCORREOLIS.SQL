DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TARARCHIVOCORREOLIS;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2TARARCHIVOCORREOLIS(
	-- Stored procedure para listar los archivos adjuntos de los correos
	Par_EnvioCorreoID				BIGINT,					-- Identificador de la notificacion de correo
	Par_NombreArchivo				VARCHAR(50),			-- Nombre del archivo
	Par_Extension					CHAR(3),				-- Extension del archivo
	Par_Archivo    			 		BLOB,					-- Contenido del archivo
	Par_NumLis						TINYINT UNSIGNED,		-- Numero de lista
	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Var_LisArchivoAdj		TINYINT;				-- Lista todos los archivos adjutos

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Var_LisArchivoAdj			:= 1;					-- Asignacion para lista de los archivos adjutos

	-- Valores por default
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);

	-- Lista todos los correos en proceso
	IF	(Par_NumLis	=	Var_LisArchivoAdj) THEN

		SELECT		ArchivoID,				EnvioCorreoID,			NombreArchivo,			Extension,				Archivo,
					PesoByte
			FROM	EDOCTAV2TARARCHIVOCORREO
			WHERE	EnvioCorreoID	= Par_EnvioCorreoID;

	END IF;

-- Fin del SP
END TerminaStore$$
