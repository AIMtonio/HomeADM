-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTARDEBEXTRACCIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPTARDEBEXTRACCIONLIS`;
DELIMITER $$

CREATE PROCEDURE `TMPTARDEBEXTRACCIONLIS`(
	Par_TarDebExtraccionID 	INT(11),			-- ID de la tabla de Extraccion.
	Par_NumLis         		TINYINT UNSIGNED,		-- Parametro numero lista

	Par_EmpresaID       	INT,					-- Parametro de Auditoria
	Aud_Usuario         	INT,					-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID      	VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal        	INT,					-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT					-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);			-- cadena vacia
	DECLARE Entero_Cero     	INT;				-- entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- DECIMAL cero
	DECLARE Lis_SubBin			INT;				-- lista de Bin y SubBin por Extraccion de archivo de tarjetas
	DECLARE Lis_Header			INT;				-- Contenido de Header por Extraccion de archivo de tarjetas
	DECLARE Lis_Contenido		INT;				-- Contenido de documento por Extraccion de archivo de tarjetas
	DECLARE Cadena_SI 			CHAR(1);			-- Cadena SI
	DECLARE Cadena_NO			CHAR(1);			-- Cadena NO
	
	DECLARE Var_NomArchivo 		VARCHAR(50);		-- Nombre de Archivo
	DECLARE Var_RutaArchivos	VARCHAR(150);		-- Carpeta de archivos

	-- Asignacion de valor a constantes
	SET Cadena_Vacia    		:= '';				-- cadena vacia
	SET Entero_Cero     		:= 0;				-- entero cero
	SET Decimal_Cero			:= '0.00';			-- DECIMAL cero
	SET Lis_SubBin   			:= 1;				-- lista de Bin y SubBin por Extraccion de archivo de tarjetas
	SET Lis_Header   			:= 2;				-- Contenido de Header por Extraccion de archivo de tarjetas
	SET Lis_Contenido   		:= 3;				-- Contenido de documento por Extraccion de archivo de tarjetas
	SET Cadena_SI				:= 'S';				-- Cadena SI
	SET Cadena_NO				:= 'N';				-- Cadena NO

	IF(Par_NumLis = Lis_SubBin) THEN
		SELECT 		Bin, 		SubBin
			FROM TMPTARDEBEXTRACCION
			WHERE TarDebExtraccionID = Par_TarDebExtraccionID
			AND TipoTarjetaDebID <> Entero_Cero
			GROUP BY TarDebExtraccionID, Bin, SubBin;
	END IF;

	IF(Par_NumLis = Lis_Header) THEN
		SELECT 		NomArchivo
            INTO 	Var_NomArchivo
            FROM TARDEBEXTRACCION
            WHERE TarDebExtraccionID = Par_TarDebExtraccionID;
            
		SELECT CONCAT(RutaArchivos, 'ExtraerTarjetas/') AS RutaARchivos
			INTO Var_RutaArchivos
			FROM PARAMETROSSIS;

		DROP TABLE IF EXISTS TMP_TARDEBEXTRACCION;
		CREATE TEMPORARY TABLE TMP_TARDEBEXTRACCION(
			Bin 				VARCHAR(8),
			SubBin 				VARCHAR(2),
			NomArchivo 			VARCHAR(200),

			PRIMARY KEY (Bin, SubBin)
		);

		INSERT INTO TMP_TARDEBEXTRACCION
			SELECT 		Bin, 		SubBin,		CONCAT(Var_RutaArchivos, Var_NomArchivo, '_', Bin, SubBin)
				FROM TMPTARDEBEXTRACCION
				WHERE TarDebExtraccionID = Par_TarDebExtraccionID
				AND TipoTarjetaDebID <> Entero_Cero
				GROUP BY TarDebExtraccionID, Bin, SubBin;

		SELECT TMP.NomArchivo, 		EXT.Contenido
			FROM TMPTARDEBEXTRACCION EXT
			INNER JOIN TMP_TARDEBEXTRACCION TMP
			WHERE EXT.TarDebExtraccionID = Par_TarDebExtraccionID
			AND EsHeader = Cadena_SI;
	END IF;

	IF(Par_NumLis = Lis_Contenido) THEN
		SELECT 		NomArchivo
            INTO 	Var_NomArchivo
            FROM TARDEBEXTRACCION
            WHERE TarDebExtraccionID = Par_TarDebExtraccionID;
            
		SELECT CONCAT(RutaArchivos, 'ExtraerTarjetas/') AS RutaARchivos
			INTO Var_RutaArchivos
			FROM PARAMETROSSIS;
			
		SELECT 		CONCAT(Var_RutaArchivos, Var_NomArchivo, '_', Bin, SubBin) AS NomArchivo, Contenido
			FROM TMPTARDEBEXTRACCION
			WHERE TarDebExtraccionID = Par_TarDebExtraccionID
			AND TipoTarjetaDebID <> Entero_Cero
			AND EsHeader = Cadena_NO;
	END IF;
END TerminaStore$$
