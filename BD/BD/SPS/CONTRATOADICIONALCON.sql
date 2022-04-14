-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOADICIONALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOADICIONALCON`;
DELIMITER $$

CREATE PROCEDURE `CONTRATOADICIONALCON`(
-- SP PARA CONSULTAR LOS DATOS ADICIONALES DIVIDIDOS POR TIPO DE REPORTE
	Par_NumCon  TINYINT UNSIGNED,   	-- Numero de Consulta

-- AUDITORIA GENERAL
	Aud_EmpresaID   	INT(11),        -- Parametro de auditoria - ID de la empresa
	Aud_Usuario   		INT(11),        -- Parametro de auditoria - ID del usuario
	Aud_FechaActual		DATETIME,     	-- Parametro de auditoria - Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria - Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria - Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria - ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria - Numero de la transaccion
)
TerminaStore: BEGIN
	
-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);		    -- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;			    -- Fecha vacia
	DECLARE	Entero_Cero		INT(11);		    -- Entero en cero
	DECLARE	Decimal_Cero	DECIMAL(12,2);		-- Decimal en cero
	DECLARE NOENCONTRADO	VARCHAR(100);	  	-- Valor que indica que no existe
	-- CONSULTA DEL REPORTE - CON RECA
	DECLARE Con_SegA	INT(2);	  		-- 01 _ ANEXO A
	DECLARE Con_SegB	INT(2);	  		-- 02 _ ANEXO B
	DECLARE Con_SegC	INT(2);	  		-- 03 _ ANEXO C
	DECLARE Con_SegD	INT(2);	  		-- 04 _ CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
	DECLARE Con_SegE	INT(2);	  		-- 05 _ PRECEPTOS LEGALES
	DECLARE Con_SegF	INT(2);	  		-- 06 _ SOLICITUD DE CREDITO DE PERSONA FISICA
	DECLARE Con_SegG	INT(2);	  		-- 07 _ SOLICITUD DE CREDITO DE PERSONA MORAL  
	-- CONSULTA DEL REPORTE - SIN RECA
	DECLARE Con_SegH	INT(2);	  		-- 08 _ AUTORIZACION DE CARGO AUTOMATICO
	DECLARE Con_SegI	INT(2);	  		-- 09 _ CESION DE DERECHOS
	DECLARE Con_SegJ	INT(2);	  		-- 10 _ DECLARATORIA DUD
	DECLARE Con_SegK	INT(2);			-- 11 _ PAGARE PAGO UNICO INTERES MENSUAL DUD
	DECLARE Con_SegL	INT(2);			-- 12 _ PAGARE PAGO UNICO
	DECLARE Con_SegM	INT(2);			-- 13 _ PAGOS ADELANTADOS OK
		
-- DECLARACION DE VARIABLES
	DECLARE FechaSis	DATE;			    -- Fecha Sistema
	DECLARE Horario		VARCHAR(100);	  	-- Horario UEAU - Horario de Atencion y Pago
	DECLARE NombreRepre	VARCHAR(200);		-- Nombre Representante

-- DECLARACION DE LLAVES PARAMETROS
	DECLARE FechaS		VARCHAR(20);	  	-- Llave Parametro - Fecha Sistema
	DECLARE Hora		VARCHAR(20);	    -- Llave Parametro - Horario UEAU
	DECLARE NombreR		VARCHAR(20);	  	-- Llave Parametro - Nombre Representante
  
	DECLARE Transaccion	BIGINT(20);	 		 -- Transaccion

-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0.00;
	SET NOENCONTRADO	:= 'NO ENCONTRADO';
	-- VALOR DEL REPORTE - CONTRATOS CON RECA
	SET Con_SegA	:= 1;		-- ANEXO A
	SET Con_SegB	:= 2;		-- ANEXO B
	SET Con_SegC	:= 3;		-- ANEXO C
	SET Con_SegD	:= 4;		-- CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
	SET Con_SegE	:= 5;		-- PRECEPTOS LEGALES
	SET Con_SegF	:= 6;		-- SOLICITUD DE CREDITO DE PERSONA FISICA
	SET Con_SegG	:= 7;		-- SOLICITUD DE CREDITO DE PERSONA MORAL
	-- VALOR DEL REPORTE - CONTRATOS SIN RECA
	SET Con_SegH	:= 8;	 	-- AUTORIZACION DE CARGO AUTOMATICO
	SET Con_SegI	:= 9;	  	-- CESION DE DERECHOS
	SET Con_SegJ	:= 10;		-- DECLARATORIA DUD
	SET Con_SegK	:= 11;		-- PAGARE PAGO UNICO INTERES MENSUAL DUD
	SET Con_SegL	:= 12;		-- REPORTE PAGARE PAGO UNICO
	SET Con_SegM	:= 13;		-- REPORTE PAGOS ADELANTADOS OK

-- ASIGNACION DE LLAVES PARAMETROS
  SET FechaS		:= 'systemDate';
  SET Hora			:= 'schedule'; 
  SET NombreR		:= 'repName';

-- CONSULTAS EN WS
	-- numCon 2, 4, 9, 10, 11, 12 - systemDate
    IF (Par_NumCon = Con_SegB		|| Par_NumCon = Con_SegD		|| Par_NumCon = Con_SegI	||
		Par_NumCon = Con_SegJ	|| Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		  SET FechaSis	:= IFNULL((SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1), Fecha_Vacia);
    END IF;

	-- numCon 4 - schedule - NOT USED 11, 12
    IF (Par_NumCon = Con_SegD	|| Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		  SET	Horario	:= IFNULL((SELECT HorarioUEAU FROM EDOCTAPARAMS LIMIT 1), Cadena_Vacia);
    END IF;

	-- numCon 3, 4, 5, 13 - repName
    IF (Par_NumCon = Con_SegC	||	Par_NumCon = Con_SegD	|| Par_NumCon = Con_SegE	||
		Par_NumCon = Con_SegM) THEN
		  SET NombreRepre	:= IFNULL((SELECT NombreRepresentante FROM PARAMETROSSIS LIMIT 1), Fecha_Vacia);
    END IF;

-- CREACION DE TABLA TMPCONTRATOSADICIONAL
	DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSADICIONAL`;

	CREATE TEMPORARY TABLE `TMPCONTRATOSADICIONAL` (
		NumTransaccion	BIGINT(20),		-- NumTransaccion para identificar n procesos a la vez
		LlaveParametro	VARCHAR(100),	-- Nombre de la columna
		ValorParametro	VARCHAR(500)	-- Valor de la columna
	);

	CALL TRANSACCIONESPRO(Transaccion);

-- INSERCIONES
	IF (Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegI	|| Par_NumCon = Con_SegJ) THEN
		INSERT INTO TMPCONTRATOSADICIONAL(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, FechaS,	FechaSis);
	END IF;

	IF (Par_NumCon = Con_SegD) THEN
		INSERT INTO TMPCONTRATOSADICIONAL(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, FechaS,	FechaSis),
				(Transaccion, Hora,		Horario),
				(Transaccion, NombreR,	NombreRepre);
	END IF;

	IF (Par_NumCon = Con_SegC	|| Par_NumCon = Con_SegE || Par_NumCon = Con_SegM) THEN
		INSERT INTO TMPCONTRATOSADICIONAL(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NombreR,	NombreRepre);
	END IF;

	IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		INSERT INTO TMPCONTRATOSADICIONAL(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, FechaS,	FechaSis);
	END IF;

	SELECT NumTransaccion, LlaveParametro, ValorParametro FROM TMPCONTRATOSADICIONAL;

  DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSADICIONAL`;
END TerminaStore$$