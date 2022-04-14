DELIMITER ;
DROP PROCEDURE IF EXISTS `REFCREDITOSCON`;
DELIMITER $$

CREATE PROCEDURE `REFCREDITOSCON`(
-- SP QUE CONSULTA LAS REFERENCIAS DE LOS CREDITOS
	Par_CreditoID				BIGINT(20),		-- Numero de Credito
	Par_TipoConsulta			TINYINT,		-- Tipo de consulta

   -- Parametros de auditoria
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
	DECLARE	Cadena_Vacia		VARCHAR(1);		-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE	SalidaSI        	CHAR(1);		-- Constante Salida SI
	DECLARE	SalidaNO        	CHAR(1);		-- Constante Salida NO
	DECLARE	StrSI        		CHAR(1);		-- Constante SI
	DECLARE	StrNO        		CHAR(1);		-- Constante NO
	DECLARE	ConsultaPrincipal	INT(11);		-- Consulta principal
	DECLARE	TipoCanalCred   	INT(11);		-- Tipo de Canal Credito

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET	SalidaSI        	:= 'S';
	SET	SalidaNO        	:= 'N';
	SET	StrSI        		:= 'S';
	SET	StrNO        		:= 'N';
	SET	ConsultaPrincipal   := 3;
	SET	TipoCanalCred       := 1;

-- Consulta Principal
IF(IFNULL(Par_TipoConsulta, Entero_Cero)) = ConsultaPrincipal THEN
	IF(EXISTS(SELECT RefPagoID
      FROM REFPAGOSXINST
		WHERE InstrumentoID = IFNULL(Par_CreditoID,Cadena_Vacia) AND TipoCanalID=TipoCanalCred))THEN

			SELECT StrSI AS Existe, InstrumentoID
			  FROM REFPAGOSXINST R
				WHERE InstrumentoID = IFNULL(Par_CreditoID,Cadena_Vacia)
					AND TipoCanalID = TipoCanalCred LIMIT 1;
	ELSE
		SELECT StrNO AS Existe, Entero_Cero AS InstrumentoID;
	END IF;
END IF;



END TerminaStore$$