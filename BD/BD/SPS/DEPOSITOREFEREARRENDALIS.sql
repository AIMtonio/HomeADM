-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREARRENDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREARRENDALIS`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREARRENDALIS`(
-- SP  QUE LISTA DEPOSITOS REFERENCIADOS DE ARRENDAMIENTO
	Par_DepRefereID		BIGINT,       		-- FOLIO DE CARGA A PROCESAR
	Par_NumLis			TINYINT UNSIGNED,	-- TIPO DE LISTA

	Aud_EmpresaID		INT(11),      		-- PARAMETRO DE AUDITORIA
	Aud_Usuario			INT(11),      		-- PARAMETRO DE AUDITORIA
	Aud_FechaActual     DATETIME,     		-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP     VARCHAR(15),    	-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID      VARCHAR(50),    	-- PARAMETRO DE AUDITORIA
	Aud_Sucursal		INT(11),      		-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion	BIGINT(20)      	-- PARAMETRO DE AUDITORIA
  )
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);		-- VALOR CERO
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Lis_Principal		CHAR(1);		-- LISTA PRINCIPAL
	DECLARE Lis_Depositos		CHAR(1);		-- LISTA DE DEPOSITOS
	DECLARE Est_NoAplicado		CHAR(1);		-- ESTATUS NO APLICADO


	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;			-- VALOR CERO
	SET Cadena_Vacia			:= '';			-- CADENA VACIA
	SET Lis_Principal			:= 1; 			-- LISTA PRINCIPAL
	SET Lis_Depositos			:= 2;			-- LISTA DE DEPOSITOS
	SET Est_NoAplicado			:= 'N';			-- ESTATUS NO APLICADO

	-- Asignacion de Variables
	SET Aud_FechaActual   := CURRENT_TIMESTAMP();

	-- LISTA PRINCIPAL
	IF (Lis_Principal = Par_NumLis) THEN
		SELECT DISTINCT D.DepRefereID,		I.NombreCorto,		D.NumCtaInstit,		D.FechaCarga
			FROM  DEPOSITOREFEARRENDA D
				INNER JOIN INSTITUCIONES    I ON D.InstitucionID = I.InstitucionID
				WHERE D.Estatus LIKE Est_NoAplicado;
	END IF;

	-- LISTA DE DEPOSITOS
	IF (Lis_Depositos = Par_NumLis) THEN
		SELECT  DepRefereID,          	FolioCargaID, 	FechaCarga,		ReferenciaMov,		CONCAT(C.ClienteID, ' - ', C.NombreCompleto) AS Cliente,
				FORMAT(MontoMov,2) AS MontoMov
			FROM DEPOSITOREFEARRENDA D
				INNER JOIN ARRENDAMIENTOS A ON D.ReferenciaMov  = A.ArrendaID
				INNER JOIN CLIENTES C		ON C.ClienteID		= A.ClienteID
				WHERE   DepRefereID = Par_DepRefereID
				  AND D.Estatus LIKE Est_NoAplicado;
	END IF;

END TerminaStore$$