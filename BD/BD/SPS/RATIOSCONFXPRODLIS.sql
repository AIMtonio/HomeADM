-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCONFXPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSCONFXPRODLIS`;DELIMITER $$

CREATE PROCEDURE `RATIOSCONFXPRODLIS`(
	/*SP PARA CONSULTAR LA CONFIGURACION DE LOS RATIOS PARAMETRIZADOS POR PRODUCTO DE CREDITO.*/
	Par_ProducCreditoID		INT(11),			# Id del producto de credito
    Par_RatiosCatalogoID	INT(11),			# Numero de ID del Catalogo de Ratios ; CATRATIOS
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

    DROP TABLE IF EXISTS TMPCATRATIOS;
	CREATE TEMPORARY TABLE TMPCATRATIOS(
	RatiosCatalogoID		INT(11) ,
	NRegistroCat			INT(11),
	INDEX(RatiosCatalogoID));


	/*
		Lista 1: Lista por Concepto por Producto
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxConcepto) THEN
		INSERT INTO TMPCATRATIOS(
			RatiosCatalogoID,NRegistroCat)
			SELECT Cat.RatiosCatalogoID,COUNT(Cat2.RatiosCatalogoID)
				FROM	CATRATIOS AS Cat
					LEFT JOIN CATRATIOS AS Cat2 ON Cat.RatiosCatalogoID = Cat2.ConceptoID
				WHERE Cat.Tipo=ListaxConcepto
				GROUP BY Cat.RatiosCatalogoID;
		SELECT
			Cat.RatiosCatalogoID,	Cat.Descripcion,	Rat.ProducCreditoID,	Cat.PorcentajeDefault AS Porcentaje,	Tmp.NRegistroCat
			FROM	CATRATIOS AS Cat LEFT JOIN
					TMPCATRATIOS AS Tmp ON Cat.RatiosCatalogoID = Tmp.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Rat ON Cat.RatiosCatalogoID=Rat.RatiosCatalogoID AND Rat.ProducCreditoID = Par_ProducCreditoID
			WHERE
				Tipo= Tipo_Concepto;
	END IF;
	/*
		Lista 2: Lista por Clasificacion por Producto
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxClasificacion) THEN
		INSERT INTO TMPCATRATIOS(
				RatiosCatalogoID,NRegistroCat)
				SELECT Cat.RatiosCatalogoID,COUNT(Cat2.RatiosCatalogoID)
					FROM	CATRATIOS AS Cat
						LEFT JOIN CATRATIOS AS Cat2 ON Cat.RatiosCatalogoID = Cat2.ClasificacionID
					WHERE Cat.Tipo=ListaxClasificacion
					GROUP BY Cat.RatiosCatalogoID;
		SELECT
			Cat.RatiosCatalogoID,	Cat.Descripcion,	Rat.ProducCreditoID,	Rat.Porcentaje,	Tmp.NRegistroCat
			FROM	CATRATIOS AS Cat LEFT JOIN
					TMPCATRATIOS AS Tmp ON Cat.RatiosCatalogoID = Tmp.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Rat ON Cat.RatiosCatalogoID=Rat.RatiosCatalogoID AND Rat.ProducCreditoID = Par_ProducCreditoID
			WHERE
				Tipo= Tipo_Clasificacion
				AND ConceptoID = Par_RatiosCatalogoID;
	END IF;

	/*
		Lista 3: Lista por SubClasificacion por Producto
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxSubClasificacion) THEN
		INSERT INTO TMPCATRATIOS(
				RatiosCatalogoID,NRegistroCat)
				SELECT Cat.RatiosCatalogoID,COUNT(Cat2.RatiosCatalogoID)
					FROM	CATRATIOS AS Cat
						LEFT JOIN CATRATIOS AS Cat2 ON Cat.RatiosCatalogoID = Cat2.SubClasificacionID
					WHERE Cat.Tipo=ListaxSubClasificacion
					GROUP BY Cat.RatiosCatalogoID;
		SELECT
				Cat.RatiosCatalogoID,	Cat.Descripcion,	Rat.ProducCreditoID,	Rat.Porcentaje,	Tmp.NRegistroCat
		FROM	CATRATIOS AS Cat LEFT JOIN
				TMPCATRATIOS AS Tmp ON Cat.RatiosCatalogoID = Tmp.RatiosCatalogoID LEFT JOIN
				RATIOSCONFXPROD AS Rat ON Cat.RatiosCatalogoID=Rat.RatiosCatalogoID AND Rat.ProducCreditoID = Par_ProducCreditoID
			WHERE
				Tipo= Tipo_SubClasificacion
				AND ClasificacionID = Par_RatiosCatalogoID;
	END IF;

	/*
		Lista 4: Lista por SubClasificacion por Producto
	*/
	IF(IFNULL(Par_TipoLista,Entero_Cero) = ListaxPuntos) THEN
		SELECT
			Cat.RatiosCatalogoID,	Cat.Descripcion,	Rat.ProducCreditoID,	LimiteInferior,			LimiteSuperior,
			Puntos,					Tmp.NRegistroCat
			FROM	CATRATIOS AS Cat LEFT JOIN
					TMPCATRATIOS AS Tmp ON Cat.RatiosCatalogoID = Tmp.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Rat ON Cat.RatiosCatalogoID=Rat.RatiosCatalogoID AND Rat.ProducCreditoID = Par_ProducCreditoID
			WHERE
				Tipo= Tipo_Puntos
				AND SubClasificacionID = Par_RatiosCatalogoID;
	END IF;

END TerminaStore$$