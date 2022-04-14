-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASASCON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMATASASCON`(
# =====================================================================================
# ------- STORED PARA CONSULTAR LOS ESQUEMAS DE TASAS DE UN PRODUCTO DE CREDITO---------
# =====================================================================================
	Par_SucursalID			INT(11),			-- ID de la sucursal
	Par_ProdCreID			INT(11),			-- ID del producto de credito
	Par_MinCredito			INT(11),			-- Numero minimos de creditos del esquema
	Par_MaxCredito			INT(11),			-- Numero maximo de creditos del esquema
	Par_Califi				VARCHAR(45),		-- Calificacion del cliente

	Par_MontoInf			DECIMAL(12,2),		-- Monto Inferior
	Par_MontoSup			DECIMAL(12,2),		-- Monoto Superior
	Par_PlazoID				VARCHAR(20),		-- ID del plazo del producto, DEFAULT es "T"=TODOS, tabla CREDITOSPLAZOS.
	Par_TasaFija			DECIMAL(12,4),		-- Tasa Fija
	Par_SobreTasa			DECIMAL(12,4),		-- Sobre tasa

	Par_EmpresaNomina		INT(11),		  	-- Si el producto es empresa de Nomina
    Par_NivelID				INT(11),			-- ID de nivel de credito
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	/*Auditoria*/
    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Con_Principal	INT(11);
	DECLARE	Con_TasaVar		INT(11);
	DECLARE	SalidaSI		CHAR(1);
	DECLARE	SalidaNO		CHAR(1);

	-- Asinacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	SET	Con_TasaVar			:= 2;
	SET	SalidaSI			:= 'S';
	SET	SalidaNO			:= 'N';

	/*Consulta 1: Principal*/
	IF(Par_NumCon = Con_Principal) THEN
		SELECT		SucursalID, 		ProductoCreditoID, 		MinCredito, 	MaxCredito, 	Calificacion,
                    MontoInferior, 		MontoSuperior, 			PlazoID,		TasaFija,		SobreTasa,
					Esq.InstitNominaID,	IFNULL(Intn.NombreInstit,Cadena_Vacia) AS NombreInstit,	NivelID
			FROM 	ESQUEMATASAS Esq
					LEFT OUTER JOIN INSTITNOMINA AS Intn
					ON Esq.InstitNominaID = Intn.InstitNominaID
			WHERE  	SucursalID 			= Par_SucursalID
			AND		ProductoCreditoID 	= Par_ProdCreID
			AND 	MinCredito			= Par_MinCredito
			AND 	MaxCredito			= Par_MaxCredito
			AND 	Calificacion		= Par_Califi
			AND 	MontoInferior		= Par_MontoInf
			AND 	MontoSuperior		= Par_MontoSup
			AND		PlazoID				= Par_PlazoID
			AND 	Esq.InstitNominaID	= Par_EmpresaNomina
            AND 	NivelID				= Par_NivelID;
	ELSEIF(Par_NumCon = Con_TasaVar) THEN
		SELECT		SucursalID, 		ProductoCreditoID, 		MinCredito, 	MaxCredito, 	Calificacion,
                    MontoInferior, 		MontoSuperior, 			PlazoID,		TasaFija,		FORMAT(SobreTasa,4) AS SobreTasa,
					Esq.InstitNominaID,	IFNULL(Intn.NombreInstit,Cadena_Vacia) AS NombreInstit,	NivelID
			FROM 	ESQUEMATASAS Esq
					LEFT OUTER JOIN INSTITNOMINA AS Intn
					ON Esq.InstitNominaID = Intn.InstitNominaID
			WHERE  	SucursalID 			= Par_SucursalID
			AND		ProductoCreditoID 	= Par_ProdCreID
			AND 	MinCredito			= Par_MinCredito
			AND 	MaxCredito			= Par_MaxCredito
			AND 	Calificacion		= Par_Califi
			AND 	MontoInferior		= Par_MontoInf
			AND 	MontoSuperior		= Par_MontoSup
			AND		PlazoID				= Par_PlazoID
			AND 	Esq.InstitNominaID	= Par_EmpresaNomina
            AND 	NivelID				= Par_NivelID
            AND		TasaFija			= Par_TasaFija;
	END IF;

END TerminaStore$$