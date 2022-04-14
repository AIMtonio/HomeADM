-- BANDESTINOSCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS BANDESTINOSCREDITOLIS;
DELIMITER $$

CREATE PROCEDURE BANDESTINOSCREDITOLIS(
	-- SP para listar los destinos de productos de creditos
	Par_ProducCreditoID	INT(11),			-- Numero de producto
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
)TerminaStore: BEGIN
	DECLARE Lis_Principal		INT;			-- Lista Principal
	DECLARE Lis_FormWeb			INT(11);		-- Lista de formulario web
	DECLARE TipoClasifCom		CHAR(1);		-- Tipo de clasificacion Comercial
	DECLARE TipoClasifCon		CHAR(1);		-- Tipo de clasificacion Consumo
	DECLARE TipoClasifHip		CHAR(1);		-- Tipo de clasificacion Hipotecario
	DECLARE NomDispCom			VARCHAR(20);	-- Descripcion de Tipo de clasificacion Comercial
	DECLARE NomDispCon			VARCHAR(20);	-- Descripcion de Tipo de clasificacion Consumo
	DECLARE NomDispHip			VARCHAR(20);	-- Descripcion de Tipo de clasificacion Hipotecario
	DECLARE Var_DestinoCre		INT(11);		-- Variable para guardar el destino de creditos

	DECLARE Entero_Cero			INT(11);		-- Entero Cero

	SET Lis_Principal			:= 1;				-- Lista Principal
	SET Lis_FormWeb				:= 2;				-- Lista de formularioWeb
	SET TipoClasifCom			:= 'C';				-- Tipo de clasificacion Comercial
	SET TipoClasifCon			:= 'O';				-- Tipo de clasificacion Consumo
	SET TipoClasifHip			:= 'H';				-- Tipo de clasificacion Hipotecario
	SET NomDispCom				:= 'Comercial';		-- Descripcion de Tipo de clasificacion Comercial
	SET NomDispCon				:= 'Consumo';		-- Descripcion de Tipo de clasificacion Consumo
	SET NomDispHip				:= 'Hipotecario';	-- Descripcion de Tipo de clasificacion Hipotecario
	SET Entero_Cero				:= 0;				-- Entero Cero

	IF (Par_NumLis = Lis_Principal) THEN

		SELECT DestinoCreditoID INTO Var_DestinoCre FROM PRODUCTOSCREDITOBE WHERE ProductoCreditoID = Par_ProducCreditoID;

		SET Var_DestinoCre := IFNULL(Var_DestinoCre, Entero_Cero);

		SELECT Dc.DestinoCreID, Dc.Descripcion, Dc.SubClasifID, Dc.Clasificacion,
			CASE Dc.Clasificacion
				WHEN TipoClasifCom THEN NomDispCom
				WHEN TipoClasifCon THEN NomDispCon
				WHEN TipoClasifHip THEN NomDispHip
			END AS descripClasifica
		FROM DESTINOSCREDPROD Dcp
		INNER JOIN DESTINOSCREDITO Dc ON Dcp.DestinoCreID = Dc.DestinoCreID
		WHERE Dc.DestinoCreID = IF(Var_DestinoCre > Entero_Cero, Var_DestinoCre, Dc.DestinoCreID)
		AND Dcp.ProductoCreditoID = Par_ProducCreditoID;
	END IF;

	IF (Par_NumLis = Lis_FormWeb) THEN
		
		SELECT Dc.DestinoCreID, Dc.Descripcion, Dc.SubClasifID, Dc.Clasificacion,
			CASE Dc.Clasificacion
				WHEN TipoClasifCom THEN NomDispCom
				WHEN TipoClasifCon THEN NomDispCon
				WHEN TipoClasifHip THEN NomDispHip
			END AS descripClasifica
		FROM PRODUCTOSCREDITOFW Dcp
		INNER JOIN DESTINOSCREDITO Dc ON Dcp.DestinoCreditoID = Dc.DestinoCreID
		WHERE Dcp.ProductoCreditoID = Par_ProducCreditoID;

	END IF;

END TerminaStore$$