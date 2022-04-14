DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSDOMICILIARWSLIS`;

DELIMITER $$
CREATE PROCEDURE `CATALOGOSDOMICILIARWSLIS`(
	Par_NumLis					INT(11), 			-- Numero de lista a consultar
	Par_EmpresaID				INT(11),			-- Parametro de Auditoria y numero de Empresa a listar
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Cons_SI				CHAR(1);
	DECLARE Lis_Nomina			INT(11);
	DECLARE Lis_Bancos			INT(11);
	DECLARE Lis_Producto		INT(11);

	-- Seteo de Valores
	SET Cons_SI					:= 'S';
	SET Lis_Nomina				:= 1;
	SET Lis_Bancos				:= 2;
	SET Lis_Producto			:= 3;


	-- 1 .- Lista de Instituciones de Nomina
	IF Par_NumLis = Lis_Nomina THEN
		SELECT `InstitNominaID` AS ID,	`NombreInstit` AS Descripcion
		FROM INSTITNOMINA;
	END IF;

	-- 2.- Lista de Instituciones Bancarias que manejan Domiciliacion
	IF Par_NumLis = Lis_Bancos THEN
		SELECT	`InstitucionID` AS ID,	`Nombre` AS Descripcion
		FROM INSTITUCIONES
		WHERE  Domicilia = Cons_SI;
	END IF;

	-- 3 .- Lista de Productos de Nomina
	IF Par_NumLis = Lis_Producto THEN
		SELECT `ProducCreditoID` AS ID, `Descripcion`
		FROM PRODUCTOSCREDITO;
	END IF;

END TerminaStore$$