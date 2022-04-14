-- SP TARCREDBLOQDESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS TARCREDBLOQDESREP;
DELIMITER $$

CREATE PROCEDURE TARCREDBLOQDESREP(
	-- SP para el reporte de bloqueo y desbloqueos de tarjetas de credito
	Par_FechaInicio			DATE,				-- Fecha de inicio
	Par_FechaFin			DATE,				-- Fecha final
	Par_Mostrar				INT(11),			-- Filtro del tipo de reporte (Bloqueo,desbloqueo, todos)
	Par_ClienteID			INT(11),			-- Identificador del numero de cliente
	Par_TipoTarjetaCredID	INT(11),			-- Tipo de tarjeta
	Par_LineaTarCred		BIGINT(12),			-- Linea de la tarjeta
	Par_Motivo				INT(11),			-- Motivo del bloqueo o desbloqueo

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia 		VARCHAR(4000);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante de cadena vacia
	DECLARE Fecha_Vacia			DATE;		-- Fecha vacia
	DECLARE Entero_Cero			INT(11);	-- Entero cero
	DECLARE FechaSist			DATE;		-- FECHA DEL SISTEMA
	DECLARE Sald_Bloqueda		CHAR(1);	-- SOLDO BLOQUEADO
	DECLARE Sald_Inactiva		CHAR(1);	-- SALDO INACTIVO
	DECLARE Sald_Registrada		CHAR(1);	-- SALDO REGISTRADO
	DECLARE Var_PerFisica		CHAR(1);	-- PERSONA FISICA
	DECLARE Est_Activo			INT(11);	-- ESTATUS ACTIVO
	DECLARE Est_Bloqueo			INT(11);	-- ESTATUS BLOQUEADO

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Sald_Bloqueda			:= 'B';
	SET Sald_Inactiva			:= 'I';
	SET Sald_Registrada			:= 'R';
	SET Var_PerFisica			:= 'F';
	SET Est_Activo				:= '7';
	SET Est_Bloqueo				:= '8';


	SET Var_Sentencia :=  'SELECT Bit.TarjetaCredID,
						   DATE(Bit.Fecha) AS Fecha,
						   UPPER(Eve.Descripcion) AS TipoEventos ,
						   UPPER(IFNULL(Cat.Descripcion,"SINCAT")) AS Catalogo,
						   UPPER(DescripAdicio) AS DescripAdicio ';
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,'FROM BITACORATARCRED AS Bit LEFT JOIN CATALCANBLOQTAR as Cat ON Cat.MotCanBloID=Bit.MotivoBloqID LEFT JOIN TARDEBEVENTOSTD AS Eve on Eve.TipoEvenTDID=Bit.TipoEvenTDID');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT JOIN TARJETACREDITO AS Tar ON Tar.TarjetaCredID=Bit.TarjetaCredID LEFT JOIN CLIENTES AS Cli on Cli.ClienteID=Tar.ClienteID');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' LEFT JOIN CUENTASAHO AS Cta ON Cta.CuentaAhoID=Tar.LineaTarCredID  LEFT JOIN TIPOTARJETADEB as Tip on Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID WHERE ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' (Date(Bit.Fecha) >= Date(?) and Date(Bit.Fecha) <= Date(?)) AND Tip.TipoTarjeta="C"');


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
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tar.TipoTarjetaCredID =',CONVERT( Par_LineaTarCred,char));
	END IF;

	IF (Par_Mostrar = Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND (Bit.TipoEvenTDID = "8" or Bit.TipoEvenTDID = "7")');
	ELSE IF(Par_Mostrar = Est_Activo) THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Bit.TipoEvenTDID =',CONVERT(Par_Mostrar,CHAR));
		ELSE IF (Par_Mostrar = Est_Bloqueo) THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Bit.TipoEvenTDID =',CONVERT(Par_Mostrar,CHAR));
			END IF;
		END IF;
	END IF;

	SET Par_TipoTarjetaCredID := IFNULL(Par_TipoTarjetaCredID ,Entero_Cero);

	IF(Par_TipoTarjetaCredID != Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND Tar.TipoTarjetaDebID =',CONVERT( Par_TipoTarjetaCredID,CHAR));
	END IF;

	-- select Var_Sentencia;
	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

	PREPARE STSESTATUSREP FROM @Sentencia;
	EXECUTE STSESTATUSREP USING @FechaInicio, @FechaFin;
	DEALLOCATE PREPARE STSESTATUSREP;

END TerminaStore$$