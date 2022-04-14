-- TARDEBEXTRACCIONDETLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBEXTRACCIONDETLIS`;
DELIMITER $$

CREATE PROCEDURE `TARDEBEXTRACCIONDETLIS`(

	Par_TarDebExtraccionID		INT(11),			-- ID de la tabla de Extraccion de archivo.
	Par_NumLista				TINYINT UNSIGNED,	-- Tipo de Lista

	Aud_EmpresaID				INT(11),			-- Parametros de Auditoria
	Aud_Usuario					INT(11),			-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);				-- Constante de cadena vacia
	DECLARE	Fecha_Vacia		DATE;					-- Constante de fecha vacia
	DECLARE	Entero_Cero		INT(11);				-- constante de entero cero
	DECLARE	Lista_RutaFinal	INT(11);

		-- Declaracion de variables
	DECLARE Var_RutaArchivo	VARCHAR(100);		-- Varibale para la ruta de los archivos

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET	Lista_RutaFinal		:= 1; 				-- Tipo de lista principal



	IF(Par_NumLista = Lista_RutaFinal) THEN
		SELECT RutaArchivos INTO Var_RutaArchivo FROM PARAMETROSSIS;

		SELECT CONCAT(Var_RutaArchivo,'ExtraerTarjetas/',NomArchivoExt) AS NomArchivoExt
			FROM TARDEBEXTRACCIONDET
			WHERE TarDebExtraccionID = Par_TarDebExtraccionID;
	END IF;


END TerminaStore$$
