-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFERENCIACLIENTEREP`;DELIMITER $$

CREATE PROCEDURE `REFERENCIACLIENTEREP`(

	Par_ProductoCredito		INT(11),
	Par_FechaIni			DATE,
	Par_FechaFin			DATE,
	Par_Interesado			CHAR(1),
    Par_TipoReporte			TINYINT UNSIGNED,

	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore:BEGIN

    DECLARE Var_Sentencia		 	VARCHAR(10000);
    DECLARE Var_SentenciaCond 		VARCHAR(10000);

    DECLARE Rep_Principal			INT(11);
    DECLARE Cadena_Vacia			CHAR(1);
    DECLARE Entero_Cero				INT(11);
    DECLARE Fecha_Vacia				DATE;


    SET Rep_Principal				:= 1;
    SET Cadena_Vacia				:= '';
    SET Entero_Cero					:= 0;
    SET Fecha_Vacia					:= '1900-01-01';

	SET Var_Sentencia				:= '';
    SET Var_SentenciaCond			:= '';

    IF(Par_TipoReporte = Rep_Principal) THEN
		SET Var_Sentencia := '
							SELECT
								RC.SolicitudCreditoID,	RC.NombreCompleto,		CONCAT(FNMASCARA(RC.Telefono,\'(###) ###-####\'),IF(LENGTH(RC.ExtTelefonoPart)>0,CONCAT(\' Ext. \',RC.ExtTelefonoPart),\'\'))AS Telefono, RC.DireccionCompleta,
								CASE WHEN C.NombreCompleto IS NULL THEN P.NombreCompleto ELSE C.NombreCompleto END AS Solicitante
								FROM
									REFERENCIACLIENTE AS RC INNER JOIN
									SOLICITUDCREDITO AS SC ON RC.SolicitudCreditoID=SC.SolicitudCreditoID LEFT JOIN
									CLIENTES AS C ON SC.ClienteID=C.ClienteID LEFT JOIN
									PROSPECTOS AS P ON SC.ProspectoID=P.ProspectoID';
		IF(IFNULL(Par_ProductoCredito,Entero_Cero) != Entero_Cero) THEN
			SET Var_SentenciaCond := CONCAT(' SC.ProductoCreditoID=',Par_ProductoCredito);
        END IF;

        IF(IFNULL(Par_FechaIni,Fecha_Vacia) != Fecha_Vacia AND IFNULL(Par_FechaFin,Fecha_Vacia) != Fecha_Vacia) THEN
			IF(IFNULL(Var_SentenciaCond,Cadena_Vacia)!=Cadena_Vacia) THEN
				SET Var_SentenciaCond := CONCAT(Var_SentenciaCond,' AND ');
			END IF;
			SET Var_SentenciaCond := CONCAT(Var_SentenciaCond,' SC.FechaRegistro BETWEEN \'',Par_FechaIni, '\' AND \'',Par_FechaFin,'\' ');
        END IF;

		IF(IFNULL(Par_Interesado,Cadena_Vacia) != Cadena_Vacia) THEN
			IF(IFNULL(Var_SentenciaCond,Cadena_Vacia)!=Cadena_Vacia) THEN
				SET Var_SentenciaCond := CONCAT(Var_SentenciaCond,' AND ');
			END IF;
			SET Var_SentenciaCond := CONCAT(Var_SentenciaCond,' RC.Interesado="',Par_Interesado, '"');
        END IF;
        IF(IFNULL(Var_SentenciaCond,Cadena_Vacia)!=Cadena_Vacia) THEN
			SET Var_SentenciaCond := CONCAT(' WHERE ',Var_SentenciaCond);
		END IF;
        SET Var_SentenciaCond :=IFNULL(Var_SentenciaCond,Cadena_Vacia);

        SET Var_Sentencia := CONCAT(Var_Sentencia,' ',Var_SentenciaCond,' ORDER BY RC.SolicitudCreditoID;');
        SET @Sentencia	= concat(Var_Sentencia);

		PREPARE SPREFERENCIACLIENTEREP FROM @Sentencia;
		EXECUTE SPREFERENCIACLIENTEREP;
	END IF;

END TerminaStore$$