-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATGARANTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATGARANTREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATGARANTREP`(
    Par_CreditoID         BIGINT(12),
	Par_TipoReporte       INT,

    Par_EmpresaID         INT(11),
    Aud_Usuario           INT(11),
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT(11),
    Aud_NumTransaccion    BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_ReqGarantia				CHAR(1);
DECLARE Var_Encabezado  			VARCHAR(400);
DECLARE Var_SolCreditoID			INT(11);
DECLARE Var_TipDesc					VARCHAR(200);
DECLARE Var_ClaDesc					VARCHAR(200);
DECLARE Var_NoIdent					VARCHAR(40);
DECLARE Var_GarantiaID				INT(11);
DECLARE Var_TipoGarantiaID			INT(11);
DECLARE Var_ClasifGarantiaID		INT(11);

-- Declaracion de Constantes
DECLARE Cadena_Vacia        		CHAR(1);
DECLARE Var_Vacio					CHAR(1);
DECLARE Entero_Cero         		INT;
DECLARE Fecha_Vacia         		DATE;
DECLARE Tipo_Detalle   				VARCHAR(200);
DECLARE Tipo_Encabezado 			CHAR(1);
DECLARE Estilo_cursiva				CHAR(1);
DECLARE CURSORGARANTIAS CURSOR FOR
SELECT Sol.SolicitudCreditoID,Asig.GarantiaID,Gar.TipoGarantiaID,Tip.Descripcion,
	   Gar.ClasifGarantiaID, Cla.Descripcion,Gar.NoIdentificacion
	FROM ASIGNAGARANTIAS Asig,
		 TIPOGARANTIAS Tip,
		 GARANTIAS Gar,
		 SOLICITUDCREDITO Sol
		INNER JOIN CLASIFGARANTIAS Cla
		WHERE Asig.SolicitudCreditoID=Sol.SolicitudCreditoID
			AND Tip.TipoGarantiasID=Gar.TipoGarantiaID
			AND Gar.GarantiaID = Asig.GarantiaID
			AND Sol.CreditoID=Par_CreditoID
			AND	Cla.ClasifGarantiaID=Gar.ClasifGarantiaID AND Gar.TipoGarantiaID=Cla.TipoGarantiaID;

-- Asignacion de Constantes
SET Cadena_Vacia        := '';              -- String Vacio
SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero         := 0;               -- Entero en Cero
SET Var_Vacio  		    := '';
SET Tipo_Detalle		:='D';
SET Tipo_Encabezado 	:='E';
SET Estilo_cursiva 		:='C';
DROP TABLE IF EXISTS  TMPGAR;
CREATE TEMPORARY TABLE TMPGAR(
    `Tmp_Descripcion`   VARCHAR(400),
    `Tmp_Tipo`          VARCHAR(400),
    `Tmp_Estilo`        VARCHAR(400)

);


OPEN CURSORGARANTIAS;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
    FETCH CURSORGARANTIAS INTO
	Var_SolCreditoID,Var_GarantiaID,Var_TipoGarantiaID,Var_TipDesc,Var_ClasifGarantiaID,Var_ClaDesc,Var_NoIdent;

	INSERT TMPGAR VALUES(CONCAT(CONCAT(Var_GarantiaID,'-'),Var_TipDesc)
						,CONCAT(CONCAT(Var_ClasifGarantiaID,'-'),Var_ClaDesc)
						,Var_NoIdent);
	END LOOP;
END;
CLOSE CURSORGARANTIAS;
  SELECT  Tmp_Descripcion,Tmp_Tipo,Tmp_Estilo
				FROM TMPGAR ;

DROP TABLE TMPGAR;

END TerminaStore$$