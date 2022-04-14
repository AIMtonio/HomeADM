-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINSTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFPAGOSXINSTLIS`;DELIMITER $$

CREATE PROCEDURE `REFPAGOSXINSTLIS`(
# ========================================================================
# ------- STORED DE LISTA DE REFERENCIAS DE PAGO POR INSTRUMENTO ---------
# ========================================================================
/* LISTA DE REI */
	Par_TipoCanalID				INT(11), 		-- ID del tipo de canal sólo para ctas y creditos. Corresponde a TIPOCANAL
	Par_InstrumentoID			BIGINT(20), 	-- ID del instrumento (CuentaAhoID, CreditoID).
    Par_TipoReferencia			CHAR(1),		-- Tipo de Referencias a = automatica, m = manual
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA: 1 para Paises en Mejora y 2 para Paises No Cooperantes

    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);
DECLARE	ListaPrincipal	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	ListaPrincipal      := 1; 				-- Tipo de lista Principal

IF(IFNULL(Par_TipoLista, Entero_Cero)) = ListaPrincipal THEN
	SELECT Origen,		InstitucionID,		NombInstitucion, 		Referencia,  	TipoReferencia
      FROM REFPAGOSXINST
		WHERE TipoCanalID = IFNULL(Par_TipoCanalID,Entero_Cero)
			AND InstrumentoID = IFNULL(Par_InstrumentoID,Entero_Cero)
			AND TipoReferencia = Par_TipoReferencia;
END IF;

END TerminaStore$$