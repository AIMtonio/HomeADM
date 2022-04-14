-- SP CHECKLISTREMESASWSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS `CHECKLISTREMESASWSLIS`;

DELIMITER $$

CREATE PROCEDURE `CHECKLISTREMESASWSLIS` (
-- ====================================================================
-- --------- STORE PARA LA LISTA DE CHECK LIST DE REMESAS -------------
-- ====================================================================
    Par_RemesaWSID          BIGINT(20),         -- Numero de la Remesa
	Par_RemesaFolioID		VARCHAR(45),		-- Indica la referencia de pago de la Remesa
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- DECLARACION DE VARIABLES
    DECLARE Var_RemesaWSID	BIGINT(20);		-- Identificador de la remesa

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero    	INT(11);		-- Entero Cero
    DECLARE Decimal_Cero	DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   	CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha Vacia
    DECLARE ConstanteSI		CHAR(1);		-- Constante: SI

	DECLARE Lis_CheckList	INT(11);		-- Lista de Check List de Remesas
	DECLARE Lis_ExpRevRem	INT(11);		-- Lista de Expedientes de Revision de Remesas

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero			:= 0; 			-- Entero Cero
    SET Decimal_Cero        := 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
    SET ConstanteSI			:= 'S';			-- Constante: SI

	SET Lis_CheckList		:= 1;			-- Lista de Check List de Remesas
	SET Lis_ExpRevRem		:= 2;			-- Lista de Expedientes de Revision de Remesas

    -- 1.- Lista de Check List de Remesas
	IF(Par_NumLis = Lis_CheckList)THEN

		-- SE OBTIENE EL NUMERO DE LA REMESA DE LA REFERENCIA DE PAGO
		SELECT RemesaWSID
		INTO Var_RemesaWSID
		FROM REMESASWS
		WHERE RemesaFolioID = Par_RemesaFolioID;

		SET Var_RemesaWSID 	:= IFNULL(Var_RemesaWSID,Entero_Cero);

		SELECT Che.CheckListRemWSID,	Tip.TipoDocumentoID,	Tip.Descripcion,	Che.Descripcion AS DescripcionDoc,	Che.Archivo AS Recurso
		FROM CHECKLISTREMESASWS Che
		INNER JOIN TIPOSDOCUMENTOS Tip
		ON Che.NumeroID = Tip.TipoDocumentoID
		WHERE Che.RemesaWSID = Var_RemesaWSID;

	END IF;

	 -- 2.- Lista de Expedientes de Revision de Remesas
	IF(Par_NumLis = Lis_ExpRevRem)THEN

		-- SE OBTIENE EL NUMERO DE LA REMESA DE LA REFERENCIA DE PAGO
		SELECT RemesaWSID
		INTO Var_RemesaWSID
		FROM REMESASWS
		WHERE RemesaFolioID = Par_RemesaFolioID;

		SET Var_RemesaWSID 	:= IFNULL(Var_RemesaWSID,Entero_Cero);

		SELECT 	Che.CheckListRemWSID,	Tip.TipoDocumentoID,	Tip.Descripcion,	Che.Descripcion AS DescripcionDoc,	Che.Archivo AS Recurso,
				TIME(NOW()) AS Hora,   IF(Che.ProgramaID ='RecordRemmitanceProDAO.remesasWSPro','W','P') AS OrigenDoc
		FROM CHECKLISTREMESASWS Che
		INNER JOIN TIPOSDOCUMENTOS Tip
		ON Che.NumeroID = Tip.TipoDocumentoID
		WHERE Che.RemesaWSID = Var_RemesaWSID;

	END IF;

END TerminaStore$$