-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORABLOQDESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORABLOQDESREP`;DELIMITER $$

CREATE PROCEDURE `TC_BITACORABLOQDESREP`(
-- SP PARA GENERAR REPORTE DE BLOQUEO O DESBLOQUEO DE TARJETA DE CREDITO
   Par_FechaInicio       DATE, 			-- Fecha de inicio de reporte
   Par_FechaFin          DATE, 			-- Fecha final del reporte
   Par_Mostrar           INT(11),
   Par_ClienteID         INT(11),		-- ID del cliente
   Par_TipoTarjetaCredID INT(11), 		-- Tipo de tarjeta
   Par_LineaTarCred      BIGINT(12),	-- Linea de credito
   Par_Motivo            INT(11), 		-- Motivo


    Par_EmpresaID       INT,			-- Auditoria
    Aud_Usuario         INT, 			-- Auditoria
    Aud_FechaActual     DATETIME, 		-- Auditoria
    Aud_DireccionIP     VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID      VARCHAR(50), 	-- Auditoria
    Aud_Sucursal        INT, 			-- Auditoria
    Aud_NumTransaccion  BIGINT 			-- Auditoria

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		VARCHAR(4000);


-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE FechaSist			DATE;		-- FECHA DEL SISTEMA
DECLARE Sald_Bloqueda		CHAR(1);	-- SOLDO BLOQUEADO
DECLARE Sald_Inactiva		CHAR(1);	-- SALDO INACTIVO
DECLARE Sald_Registrada		CHAR(1);	-- SALDO REGISTRADO
DECLARE Var_PerFisica 	    CHAR(1);	-- PERSONA FISICA
DECLARE Est_Activo         	INT;		-- ESTATUS ACTIVO
DECLARE Est_Bloqueo        	INT;		-- ESTATUS BLOQUEADO


-- Asignacion de Constantes
SET Cadena_Vacia	       	:= '';
SET Fecha_Vacia		       	:= '1900-01-01';
SET Entero_Cero		       	:= 0;
SET Sald_Bloqueda		    := 'B';
SET Sald_Inactiva		    := 'I';
SET Sald_Registrada		 	:= 'R';
SET Var_PerFisica       	:= 'F';
SET Est_Activo            	:= '7';
SET Est_Bloqueo           	:= '8';



    SET Var_Sentencia :=  'SELECT Bit.TarjetaCredID,
						   DATE(Bit.Fecha) AS Fecha,
                           UPPER(Eve.Descripcion) AS TipoEventos ,
                           UPPER(Cat.Descripcion) AS Catalogo,
                           UPPER(DescripAdicio) AS DescripAdicio ';
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,'FROM TC_BITACORA AS Bit LEFT JOIN CATALCANBLOQTAR AS Cat ON Cat.MotCanBloID=Bit.MotivoBloqID LEFT JOIN TARDEBEVENTOSTD AS Eve ON Eve.TipoEvenTDID=Bit.TipoEvenTDID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT JOIN TARJETACREDITO AS Tar ON Tar.TarjetaCredID=Bit.TarjetaCredID LEFT JOIN CLIENTES AS Cli ON Cli.ClienteID=Tar.ClienteID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT JOIN LINEATARJETACRED AS LNA ON LNA.LineatarCredID=Tar.LineaTarCredID  LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID WHERE ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' (DATE(Bit.Fecha) >= DATE(?) AND DATE(Bit.Fecha) <= DATE(?)) AND Tip.TipoTarjeta="C"');


	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.ClienteID =', CONVERT(Par_ClienteID,CHAR));
    END IF;

    SET Par_Motivo	 := IFNULL(Par_Motivo,Entero_Cero);
    IF(Par_Motivo	!=  Entero_Cero)THEN
            SET Var_Sentencia = CONCAT(Var_sentencia,' AND Bit.MotivoBloqID =',CONVERT(Par_Motivo,CHAR));
	END IF;

    SET Par_LineaTarCred := IFNULL(Par_LineaTarCred ,Entero_Cero);

    IF(Par_LineaTarCred != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tar.TipoTarjetaCredID =',CONVERT( Par_LineaTarCred,CHAR));
    END IF;


    IF (Par_Mostrar = Entero_Cero ) THEN
        SET Var_Sentencia := CONCAT(Var_sentencia,' AND (Bit.TipoEvenTDID = "8" OR Bit.TipoEvenTDID = "7")');
    ELSE IF(Par_Mostrar = Est_Activo) THEN
            SET Var_Sentencia := CONCAT(Var_sentencia,' AND Bit.TipoEvenTDID =',CONVERT(Par_Mostrar,CHAR));
        ELSE IF (Par_Mostrar = Est_Bloqueo) THEN
            SET Var_Sentencia := CONCAT(Var_sentencia,' AND Bit.TipoEvenTDID =',CONVERT(Par_Mostrar,CHAR));
            END IF;
        END IF;
    END IF;

    SET Par_TipoTarjetaCredID := IFNULL(Par_TipoTarjetaCredID ,Entero_Cero);

    IF(Par_TipoTarjetaCredID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tar.TipoTarjetaCredID =',CONVERT( Par_TipoTarjetaCredID,CHAR));
    END IF;

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio= Par_FechaInicio;
	SET @FechaFin	= Par_FechaFin;

   PREPARE STSESTATUSREP FROM @Sentencia;
      EXECUTE STSESTATUSREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSESTATUSREP;




END TerminaStore$$