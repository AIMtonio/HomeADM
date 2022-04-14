-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDMATRIZRIESGOPUNTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDMATRIZRIESGOPUNTOSLIS`;DELIMITER $$

CREATE PROCEDURE `PLDMATRIZRIESGOPUNTOSLIS`(
	/*SP PARA CONSULTAR LA CONFIGURACION DE LOS RATIOS PARAMETRIZADOS POR PRODUCTO DE CREDITO.*/
	Par_MatrizCatalogoID	INT(11),			# Numero de ID del Catalogo
	Par_TipoLista			TINYINT,			# Numero de lista
	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN
	# DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Tipo_Concepto			INT(11);		# Tipo Concepto; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_Clasificacion		INT(11);		# Tipo Clasificacion; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_SubClasificacion	INT(11);		# Tipo SubClasificacion; Aplica para el filtro de CATRATIOS
	DECLARE Tipo_Puntos				INT(11);		# Tipo Puntos; Aplica para el filtro de CATRATIOS
	DECLARE ListaxConcepto			INT(11);		# Lista por concepto por Producto
	DECLARE ListaxClasificacion		INT(11);		# Lista por Clasificacion por Producto
	DECLARE ListaxSubClasificacion	INT(11);		# Lista por SubClasificacion por Producto
	DECLARE ListaxPuntos			INT(11);		# Lista por Puntos por Producto

	# ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Tipo_Concepto				:= 1;
	SET Tipo_Clasificacion			:= 2;
	SET Tipo_SubClasificacion		:= 3;
	SET Tipo_Puntos					:= 4;
	SET ListaxConcepto				:= 1;
	SET ListaxClasificacion			:= 2;
	SET ListaxSubClasificacion		:= 3;
	SET ListaxPuntos				:= 4;

	/*
		Lista 1: Lista por Concepto
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxConcepto) THEN
		SELECT
			PLD.MatrizCatalogoID,		PLD.Tipo,		PLD.MatrizConceptoID,		PLD.Descripcion,			PLD.Porcentaje,
			PLD.Orden,					PLD.TipoPersona,PLD.MostrarSub,				PLD.Descripcion AS ConceptoDesc
			FROM PLDMATRIZRIESGOXCONC AS PLD
			WHERE PLD.Tipo = 1;
	END IF;

	/*
		Lista 2: Lista por Clasificacion
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxClasificacion) THEN
		SELECT
			PLD.MatrizCatalogoID,		PLD.Tipo,		PLD.MatrizConceptoID,		PLD.Descripcion,			PLD.Porcentaje,
			PLD.Orden,					PLD.TipoPersona,PLD.MostrarSub,				PLD2.Descripcion AS ConceptoDesc
			FROM PLDMATRIZRIESGOXCONC AS PLD
			INNER JOIN PLDMATRIZRIESGOXCONC AS PLD2 ON PLD.MatrizConceptoID = PLD2.MatrizCatalogoID
			WHERE PLD.Tipo = 2
			AND PLD.MatrizConceptoID = Par_MatrizCatalogoID;
	END IF;

	/*
		Lista 3: Lista por Clasificacion
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxSubClasificacion) THEN
		SELECT
			PLD.MatrizCatalogoID,		PLD.Tipo,		PLD.MatrizConceptoID,		PLD.Descripcion,			PLD.Porcentaje,
			PLD.Orden,					PLD.TipoPersona,PLD.MostrarSub,				PLD2.Descripcion AS ConceptoDesc
			FROM PLDMATRIZRIESGOXCONC AS PLD
			INNER JOIN PLDMATRIZRIESGOXCONC AS PLD2 ON PLD.MatrizConceptoID = PLD2.MatrizCatalogoID
			WHERE PLD.Tipo = 3
			AND PLD.MatrizConceptoID = Par_MatrizCatalogoID;
	END IF;

END TerminaStore$$