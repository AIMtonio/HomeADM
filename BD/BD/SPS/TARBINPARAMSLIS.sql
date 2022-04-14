-- TARBINPARAMSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBINPARAMSLIS`;
DELIMITER $$

CREATE PROCEDURE `TARBINPARAMSLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE PARAMETROS BIN ---------
# =====================================================================================
	Par_Descripcion			VARCHAR(300), 		-- Descripcion
   	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Con_Activo 			VARCHAR(30);		-- activo
	DECLARE Con_Desactivado		VARCHAR(30);		-- desactivado
	DECLARE Con_CadenaS			CHAR(1);			-- Cadena S

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Lis_BINS			INT(11);			-- Lista 1: de bins
    DECLARE Lis_BINSGrid		INT(11);			-- Lista 2: de bins gird

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';
	SET Con_Activo 				:= 'Activo';
	SET Con_Desactivado 		:= 'Desactivado';
	SET Con_CadenaS				:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Lis_BINS				:= 1;
    SET Lis_BINSGrid			:= 2;


	-- Lista 1 - PRINCIPAL
	IF(Par_NumLis = Lis_BINS) THEN
		SELECT  TP.TarBinParamsID,	TP.NumBIN,		TP.EsSubBin,	TP.EsBinMulEmp,	CT.Descripcion AS DescMarcaTar
		FROM TARBINPARAMS TP
			INNER JOIN CATMARCATARJETA CT ON TP.CatMarcaTarjetaID = CT.CatMarcaTarjetaID
				WHERE NumBIN LIKE CONCAT("%", Par_Descripcion, "%")
				ORDER BY TarBinParamsID
				LIMIT 0,15;
	END IF;

	-- Lista 2 - GRID
	IF(Par_NumLis = Lis_BINSGrid) THEN
		SELECT  TP.TarBinParamsID,	TP.NumBIN,
		CASE EsSubBin WHEN Con_CadenaS
			THEN Con_Activo
			ELSE Con_Desactivado END AS SUBBIN,
		CASE EsBinMulEmp WHEN Con_CadenaS
			THEN Con_Activo
            ELSE Con_Desactivado END AS BINMULTIBASE,
            CT.Descripcion AS DescMarcaTar
		FROM TARBINPARAMS TP
		INNER JOIN CATMARCATARJETA CT ON TP.CatMarcaTarjetaID = CT.CatMarcaTarjetaID;
	END IF;

END TerminaStore$$
