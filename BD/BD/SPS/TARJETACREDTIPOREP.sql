-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETACREDTIPOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETACREDTIPOREP`;DELIMITER $$

CREATE PROCEDURE `TARJETACREDTIPOREP`(
-- SP para generar reporte por tipo de tarjeta
    Par_FechaInicio       DATE,			-- Fecha de inicio
    Par_FechaFin          DATE, 		-- Fecha Final
    Par_TipoTarjetaCredID  INT(11),     -- Tipo de tarjeta

    Par_EmpresaID         INT,			-- Auditoria
    Aud_Usuario           INT, 			-- Auditoria
    Aud_FechaActual       DATETIME, 	-- Auditoria
    Aud_DireccionIP       VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID        VARCHAR(50), 	-- Auditoria
    Aud_Sucursal          INT, 			-- Auditoria
    Aud_NumTransaccion    BIGINT 		-- Auditoria

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		VARCHAR(4000);

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;


-- Asignacion de Constantes
SET Cadena_Vacia	       := '';
SET Fecha_Vacia		       := '1900-01-01';
SET Entero_Cero		       := 0;


    SET Var_Sentencia :=  ' SELECT TarjetaCredID,
							Est.Descripcion AS Estatus,
							LPAD(CONVERT(Tar.LineaTarCredID, CHAR),10,0) AS LineaTarCredID,
                            NombreCompleto,
                            Tipo.Descripcion AS TipoTarjeta,
                            Etiqueta ';
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,'FROM TARJETACREDITO AS Tar LEFT JOIN ESTATUSTD AS Est ON Tar.Estatus=Est.EstatusID LEFT JOIN CLIENTES AS Cli ON Cli.ClienteID=Tar.ClienteID LEFT JOIN TIPOTARJETADEB AS Tipo');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ON Tipo.TipoTarjetaDebID=Tar.TipoTarjetaCredID LEFT JOIN CUENTASAHO AS Cta ON Cta.CuentaAhoID=Tar.LineaTarCredID WHERE ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Tar.FechaRegistro >= ? AND Tar.FechaRegistro <= ? AND Tipo.TipoTarjeta="C" ');



    SET Par_TipoTarjetaCredID := IFNULL(Par_TipoTarjetaCredID, Entero_Cero);
    IF(Par_TipoTarjetaCredID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tar.TipoTarjetaDebID =',CONVERT( Par_TipoTarjetaCredID,CHAR));
    END IF;

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSESTATUSREP FROM @Sentencia;
      EXECUTE STSESTATUSREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSESTATUSREP;




END TerminaStore$$