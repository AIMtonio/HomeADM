-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTRECIBOCAPREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTRECIBOCAPREP`;
DELIMITER $$

CREATE PROCEDURE `APORTRECIBOCAPREP`(
    -- SP QUE GENERA EL REPORTE DE CONVENIO DE APORTACIONES
    Par_AportacionID	    INT(11),			-- Tipo de aportacion
    Par_NumCon				INT(11),			-- Numero de reporte
    Aud_EmpresaID			INT(11),			-- Parametro de auditoria

    Aud_Usuario				INT(11),			-- Parametro de auditoria
    Aud_FechaActual			DATETIME,			-- Parametro de auditoria
    Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
    Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
    Aud_Sucursal			INT(11),				-- Parametro de auditoria
    
    Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	-- VARIABLES GENERALES
	DECLARE Var_NumRecibo		INT(11);		-- ID de la aportacion
	DECLARE Var_MontoAport	 	DECIMAL(14,2);	-- Monto de la aportacion (Solo capital)
	DECLARE Var_MontoAportLetra	VARCHAR(300);	-- Monto de la aportacion en letra
	DECLARE Var_FechaSuscrip	DATE;			-- Fecha de inicio de la aportacion
	DECLARE Var_FechaVencim		DATE;			-- Fecha de vencimiento de la aportacion
	DECLARE Var_NumRegistro		INT(11);		-- ID del cliente
	DECLARE Var_NombreAport		VARCHAR(300);	-- Nombre o razon social del aportante
	DECLARE Var_RepLegalAport	VARCHAR(300);	-- Nombre completo del representante legal del aportante (Persona Moral)
	DECLARE Var_DiaVencimNum  	VARCHAR(2);		-- Dia en numero de la fecha de vencimiento de aportacion
	DECLARE Var_DiaVencimLetra  VARCHAR(50);	-- Dia en letra de la fecha de vencimiento de aportacion
	DECLARE Var_MesAnioVencim  	VARCHAR(60);	-- Mes y anio de vencimiento de la aportacion
	DECLARE Var_AnioLetraVencim VARCHAR(50);	-- Anio en letra de la fecha de vencimiento de la aportacion
	DECLARE Var_TasaNum			DECIMAL(14,2);	-- Tasa de rendimiento de la aportacion
	DECLARE Var_TasaLetra		VARCHAR(300);	-- Tasa de rendimiento de la aportacion en letra
	DECLARE Var_Representante	VARCHAR(300);	-- Nombre completo del representante legal de la empresa
	DECLARE Var_DirecInstit		VARCHAR(500);	-- Direccion de la financiera
	DECLARE Var_CuentaAhoID		BIGINT(20);		-- Cuenta de ahorro ligada a la aportacion
	DECLARE Var_RelacionadoID	INT(11);		-- ID del relacionado a la cuenta
	DECLARE Var_TipoPersona		CHAR(2);		-- Tipo persona del aportante F:Fisica, M:Moral

	-- VARIABLES PARA RECIBO IRREGULAR MENSUAL
	DECLARE Var_NumPagos			INT(11);		-- Numero de pagos de la aportacion
	DECLARE Var_NumPagosLetra		VARCHAR(100);	-- Numero de pagos de la aportacion en letra
	DECLARE Var_IntBrutoPago1		DECIMAL(18,2);	-- Monto de intereses brutos de la primer cuota de la aportación en numero
	DECLARE Var_IntBrutoPago1Le		VARCHAR(300);	-- Monto de intereses brutos de la primer cuota de la aportación en letra
	DECLARE Var_NumPagosReg			INT(11);		-- Numero de pagos regulares de la aportacion
	DECLARE Var_NumPagosRegLet		VARCHAR(100);	-- Numero de pagos regulares de la aportacion en letra
	DECLARE Var_MontoIntBrutoR		DECIMAL(18,2);	-- Monto de intereses brutos por cada cuota regular de la aportación en numero
	DECLARE Var_MontoIntBrutoRL		VARCHAR(300);	-- Monto de intereses brutos por cada cuota regular de la aportación en letra
	DECLARE Var_DiaPagoInt			INT(11);		-- Dias de pago de la aportacion
	DECLARE Var_DiaPagoIntLet		VARCHAR(100);	-- Dias de pago de la aportacion en letra
	DECLARE Var_DiaPrimPagoInt		INT(11);		-- Dia del mes del primer pago de intereses de la aportacion
	DECLARE Var_DiaPrimPagoInttLet	VARCHAR(100);	-- Dia del mes del primer pago de intereses de la aportacion en letra
	DECLARE Var_MesAnioPrimPago		VARCHAR(200);	-- Mes y anio del primer pago de intereses en la aportacion
	DECLARE Var_AnioPrimPagLetra	VARCHAR(200);	-- Anio del primer pago de intereses de la aportacion
	DECLARE Par_ClienteID			BIGINT(12);		-- ID del cliente
	DECLARE Par_InstitucionID		INT(11);		-- ID de la institucion parametrizada en en la pantalla parametros generales


	-- Variables para el manejo de parrafos dinamicos con negritas
    DECLARE Var_CadEncFis	VARCHAR(3000);	-- Parrafo de encabezado persona fisica
    DECLARE Var_NumLineasF	INT(11);		-- Numero de renglones del parrafo
    DECLARE Var_LongLineaF	INT(11);		-- Numero de caracteres de cada renglon
    
    DECLARE Var_Cadena 		VARCHAR(3000);  -- Parrafo de recibo irregular mensual
    DECLARE Var_NumLineas	INT(11);		-- Numero de renglones del parrafo
    DECLARE Var_LongLinea	INT(11);		-- Numero de caracteres de cada renglon
    DECLARE Var_CantNegrita	INT(11);
    -- DECLARE Var_NumLineas	INT(11);

		-- DECLARACION DE CONSTANTES
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT(11);
	DECLARE Cons_Nacion		CHAR(1);
	DECLARE Con_ReciboCap	INT(11);
	DECLARE Con_ReciboIrre	INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Cadena_Cero		CHAR(1);
	DECLARE Persona_Moral	CHAR(1);
	DECLARE Cons_Nacional	VARCHAR(30);
	DECLARE Cons_Extranje	VARCHAR(30);
	DECLARE Cons_SI			CHAR(1);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Entero_Uno		INT(11);
	DECLARE Pago_Regular	CHAR(1);
	DECLARE Con_ReciboRegu 	INT(11);

	-- Asignacion de CONSTANTES
	SET Fecha_Vacia         := '1900-01-01';-- fecha para valores vacios
	SET Entero_Cero         := 0;  			-- Constante Valor Cero
	SET Cons_Nacion         := 'N';			-- Constante nacional
	SET Con_ReciboCap		:= 1;			-- Consulta para datos generales de la aportacion
	SET Con_ReciboIrre		:= 2;			-- Consulta de recibo irregular mensual
	SET Con_ReciboRegu		:= 3;			-- Consulta de recibo regular mensual
	SET Cadena_Vacia		:= '';			-- Constante cadena vacia
	SET Cadena_Cero			:= '0';			-- Constante cadena ceros
	SET Persona_Moral		:= 'M';			-- Constante para tipo persona moral
	SET Cons_Nacional		:= 'MEXICANA';	-- Nacionalidad mexicana
 	SET Cons_Extranje		:= 'EXTRANJERA';-- Nacionalidad Extranjera
 	SET Cons_SI				:= 'S';			-- Constante si
 	SET Decimal_Cero		:= 0.00;		-- Constante decimal cero
 	SET Entero_Uno			:= 1;			-- Constante entero uno
 	SET Pago_Regular		:= 'R';			-- Constante para pagos regulares
    
    SELECT InstitucionID
		INTO Par_InstitucionID
		FROM PARAMETROSSIS
        WHERE EmpresaID = 1;
    
    SELECT ClienteID INTO Par_ClienteID
		FROM APORTACIONES
        WHERE AportacionID = Par_AportacionID;

	SET Var_NumRegistro := Par_ClienteID;

-- SECCION PARA OBTENER LOS DATOS PARA EL REPORTE "RECIBO CAPITALIZABLE"
	IF(Par_NumCon = Con_ReciboCap)THEN

		-- Obteniendo valores a utilizar de la Aportacion
		SELECT	FechaInicio,FechaVencimiento, CuentaAhoID,AportacionID,Monto,ClienteID,TasaFija
				INTO Var_FechaSuscrip,Var_FechaVencim,Var_CuentaAhoID,Var_NumRecibo,Var_MontoAport,Var_NumRegistro,Var_TasaNum
				FROM 	APORTACIONES
				WHERE 	AportacionID	= Par_AportacionID;

		SET Var_MontoAport 		:= IFNULL(Var_MontoAport,Decimal_Cero);
		SET Var_MontoAportLetra := FUNCIONNUMLETRAS(Var_MontoAport);

		SET Var_FechaSuscrip	:= IFNULL(Var_FechaSuscrip,Fecha_Vacia);
		SET Var_TasaNum			:= IFNULL(Var_TasaNum,Decimal_Cero);
		SET Var_TasaLetra		:= FUNCIONNUMEROSLETRAS(Var_TasaNum);

		-- OBTENER DATOS DE LA FECHA DE VENCIMIENTO DE LA APORTACION
		SET Var_FechaVencim := IFNULL(Var_FechaVencim,Fecha_Vacia);
		SET Var_CuentaAhoID	  := IFNULL(Var_CuentaAhoID,Entero_Cero);

		SET Var_DiaVencimNum		:= DAY(Var_FechaVencim);
		SET Var_DiaVencimNum		:= IF(Var_DiaVencimNum<10,CONCAT(Cadena_Cero,Var_DiaVencimNum),Var_DiaVencimNum);
		SET Var_DiaVencimLetra		:= FUNCIONNUMEROSLETRAS(Var_DiaVencimNum);

		SET Var_MesAnioVencim		:= CONCAT(UPPER(FUNCIONMESNOMBRE(Var_FechaVencim)),' de ', YEAR(Var_FechaVencim));
		SET Var_AnioLetraVencim		:= FUNCIONNUMEROSLETRAS(YEAR(Var_FechaVencim));


		-- OBTENER EL TIPO DE PERSONA DEL CLIENTE
		SELECT	TipoPersona
				INTO Var_TipoPersona
				FROM 	CLIENTES
				WHERE 	ClienteID	= Par_ClienteID;

		-- OBTENER DATOS DEL CLIENTE
		SELECT	IF(Var_TipoPersona=Persona_Moral,cli.RazonSocial,cli.NombreCompleto)
			INTO Var_NombreAport
			FROM 	CLIENTES cli
			WHERE 	cli.ClienteID	= Par_ClienteID;


		-- OBTENER LOS DATOS DEL REPRESENTANTE LEGAL
		IF(Var_TipoPersona = Persona_Moral)THEN
			-- obtener nombre del representante legal
			SELECT NombreCompleto
				INTO Var_RepLegalAport
				FROM CUENTASPERSONA
				WHERE CuentaAhoID=Var_CuentaAhoID
				AND EsApoderado = Cons_SI
				ORDER BY PersonaID ASC
				LIMIT 1 ;
			SET Var_RepLegalAport := IFNULL(Var_RepLegalAport,Cadena_Vacia);

		ELSE
			SET Var_RepLegalAport	:= IFNULL(Var_RepLegalAport,Cadena_Vacia);
		END IF;

		-- OBTENER EL NOMBRE DEL REPRESENTANTE LEGAL DE LA FINANCIERA
		SET Var_Representante := (SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET Var_Representante := IFNULL(Var_Representante,Cadena_Vacia);

		SET Var_DirecInstit	  := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);

		-- SELECT FINAL
		SELECT 	Var_NumRecibo,
				CAST(FORMAT(Var_MontoAport,2) AS CHAR) AS Var_MontoAport,
				CONCAT(Var_MontoAportLetra,'M.N.') AS Var_MontoAportLetra,
				FNFECHATEXTO(Var_FechaSuscrip) AS Var_FechaSuscrip,
				FNFECHATEXTO(Var_FechaVencim) AS Var_FechaVencim,
				CAST(Var_NumRegistro AS CHAR) AS Var_NumRegistro,
				Var_NombreAport,
				Var_RepLegalAport,
				Var_DiaVencimNum,
				RTRIM(Var_DiaVencimLetra) AS Var_DiaVencimLetra,
				Var_MesAnioVencim,
				RTRIM(Var_AnioLetraVencim) AS Var_AnioLetraVencim,
				CAST(Var_TasaNum AS CHAR) AS Var_TasaNum,
				Var_TasaLetra,
				Var_Representante,
				Var_DirecInstit,
				Var_TipoPersona;
	END IF; -- FIN CONSULTA PRINCIPAL

-- SECCION PARA OBTENER LOS DATOS PARA EL REPORTE "RECIBO IRREGULAR MENSUAL"
	IF(Par_NumCon = Con_ReciboIrre)THEN

		-- Obteniendo valores a utilizar de la Aportacion
		SELECT	FechaInicio,FechaVencimiento, CuentaAhoID,AportacionID,Monto,ClienteID,TasaFija,DiasPago
				INTO Var_FechaSuscrip,Var_FechaVencim,Var_CuentaAhoID,Var_NumRecibo,Var_MontoAport,Var_NumRegistro,Var_TasaNum,Var_DiaPagoInt
				FROM 	APORTACIONES
				WHERE 	AportacionID	= Par_AportacionID;

		SET Var_MontoAport 		:= IFNULL(Var_MontoAport,Decimal_Cero);
		SET Var_MontoAportLetra := FUNCIONNUMLETRAS(Var_MontoAport);

		SET Var_FechaSuscrip	:= IFNULL(Var_FechaSuscrip,Fecha_Vacia);
		SET Var_TasaNum			:= IFNULL(Var_TasaNum,Decimal_Cero);
		SET Var_TasaLetra		:= FUNCIONNUMEROSLETRAS(Var_TasaNum);

		-- OBTENER DATOS DE LA FECHA DE VENCIMIENTO DE LA APORTACION
		SET Var_FechaVencim := IFNULL(Var_FechaVencim,Fecha_Vacia);
		SET Var_CuentaAhoID	  := IFNULL(Var_CuentaAhoID,Entero_Cero);

		SET Var_DiaVencimNum		:= DAY(Var_FechaVencim);
		SET Var_DiaVencimNum		:= IF(Var_DiaVencimNum<10,CONCAT(Cadena_Cero,Var_DiaVencimNum),Var_DiaVencimNum);
		SET Var_DiaVencimLetra		:= FUNCIONNUMEROSLETRAS(Var_DiaVencimNum);

		SET Var_MesAnioVencim		:= CONCAT(UPPER(FUNCIONMESNOMBRE(Var_FechaVencim)),' de ', YEAR(Var_FechaVencim));
		SET Var_AnioLetraVencim		:= FUNCIONNUMEROSLETRAS(YEAR(Var_FechaVencim));


		-- OBTENER EL TIPO DE PERSONA DEL CLIENTE
		SELECT	TipoPersona
				INTO Var_TipoPersona
				FROM 	CLIENTES
				WHERE 	ClienteID	= Par_ClienteID;

		-- OBTENER DATOS DEL CLIENTE
		SELECT	IF(Var_TipoPersona=Persona_Moral,cli.RazonSocial,cli.NombreCompleto)
			INTO Var_NombreAport
			FROM 	CLIENTES cli
			WHERE 	cli.ClienteID	= Par_ClienteID;


		-- OBTENER LOS DATOS DEL REPRESENTANTE LEGAL
		IF(Var_TipoPersona = Persona_Moral)THEN
			-- obtener nombre del representante legal
			SELECT NombreCompleto
				INTO Var_RepLegalAport
				FROM CUENTASPERSONA
				WHERE CuentaAhoID=Var_CuentaAhoID
				AND EsApoderado = Cons_SI
				ORDER BY PersonaID ASC
				LIMIT 1 ;
			SET Var_RepLegalAport := IFNULL(Var_RepLegalAport,Cadena_Vacia);

		ELSE
			SET Var_RepLegalAport	:= IFNULL(Var_RepLegalAport,Cadena_Vacia);
		END IF;

		-- OBTENER EL NOMBRE DEL REPRESENTANTE LEGAL DE LA FINANCIERA
		SET Var_Representante := (SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET Var_Representante := IFNULL(Var_Representante,Cadena_Vacia);

		SET Var_DirecInstit	  := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);

		-- OBTENER DATOS PARA CUOTAS DE LA APORTACION
		SET Var_NumPagos 		:= (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID);
		SET Var_NumPagosLetra	:= RTRIM(FUNCIONNUMEROSLETRAS(Var_NumPagos));

		SET Var_IntBrutoPago1 	:= (SELECT Interes FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID AND AmortizacionID = Entero_Uno);
		SET Var_IntBrutoPago1Le	:= RTRIM(FUNCIONNUMLETRAS(Var_IntBrutoPago1));

		SET Var_NumPagosReg 	:= (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID AND TipoPeriodo = Pago_Regular);
		SET Var_NumPagosReg 	:= IFNULL(Var_NumPagosReg,Entero_Cero);
		SET Var_NumPagosRegLet	:= RTRIM(FUNCIONNUMEROSLETRAS(Var_NumPagosReg));

		SET Var_MontoIntBrutoR 	:= (SELECT Interes FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID AND TipoPeriodo = Pago_Regular LIMIT 1);
		SET Var_MontoIntBrutoR 	:= IFNULL(Var_MontoIntBrutoR,Decimal_Cero);
		SET Var_MontoIntBrutoRL	:= RTRIM(FUNCIONNUMLETRAS(Var_MontoIntBrutoR));

		SET Var_DiaPagoIntLet 	:= RTRIM(FUNCIONNUMEROSLETRAS(Var_DiaPagoInt));

		SELECT DAY(FechaPago), CONCAT(FUNCIONMESNOMBRE(FechaPago),' ',YEAR(FechaPago)),RTRIM(FUNCIONNUMEROSLETRAS(YEAR(FechaPago)))
									INTO Var_DiaPrimPagoInt, Var_MesAnioPrimPago,Var_AnioPrimPagLetra
									FROM AMORTIZAAPORT
									WHERE AportacionID=Par_AportacionID
									AND AmortizacionID = Entero_Uno ;

		SET Var_DiaPrimPagoInttLet := RTRIM(FUNCIONNUMEROSLETRAS(Var_DiaPrimPagoInt));
        
        -- seccion para parrafo de encabezado, para persona fisica
        IF(Var_TipoPersona <> Persona_Moral)THEN
			SET Var_CadEncFis := CONCAT("{\\rtf1 POR EL VALOR RECIBIDO, el suscrito, {\\b PREVICREM, S.A. DE C.V., SOFOM, E.N.R.} (“La Financiera”), recibe bajo ",
								"el amparo del Convenio de Aportaciones No. {\\b ",Var_NumRegistro,"} de {\\b ",Var_NombreAport,"} (“El Aportante”), ",
								"la suerte principal de {\\b $",CAST(FORMAT(Var_MontoAport,2) AS CHAR),"} ({\\b ",Var_MontoAportLetra,"}).",
								" Esta aportación podrá ser convertida en acciones representativas del capital social",
								" o devuelta el día {\\b ",Var_DiaVencimNum,"}", 
								" ({\\b ",Var_DiaVencimLetra,"}) de {\\b ",Var_MesAnioVencim," (",Var_AnioLetraVencim,")}.:");
			SET Var_CantNegrita := LENGTH(Var_NumRegistro)+LENGTH(Var_NombreAport)+LENGTH(Var_MontoAport)+
								LENGTH(Var_MontoAportLetra) + LENGTH(Var_DiaVencimNum)+
                                LENGTH(Var_DiaVencimLetra) + LENGTH(Var_MesAnioVencim)+
                                LENGTH(Var_AnioLetraVencim)+2;
			
            SET Var_NumLineasF:=0;
			SET Var_LongLineaF:=0;
			
			-- Llamada a SP para obtner la longitud de la linea y el numero de renglones del parrafo
			CALL CALCLINEASPRO(Var_CadEncFis,Var_CantNegrita,121,Var_LongLineaF,Var_NumLineasF,
					Aud_EmpresaID,Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,Aud_Sucursal,Aud_NumTransaccion);
        END IF;
		
		
        
        -- Seccion para obtener el parrafo dinamico
        SET Var_Cadena=CONCAT("{\\rtf1 La Financiera además promete pagar a El Aportante intereses sobre la cantidad",
		   " de la suerte principal insoluta de este",
		  " instrumento, a razón del {\\b ",Var_TasaNum,"% (",Var_TasaLetra," por ciento)} anual, pagaderos en forma mensual al vencimiento",
		  " de cada uno de los meses correspondientes. Los intereses causados serán pagaderos y exigibles mediante la ejecución",
		  " de {\\b  ",Var_NumPagos," (",Var_NumPagosLetra,")} pagos mensuales consecutivos, el primero por valor de",
		  " {\\b $",Var_IntBrutoPago1," (",Var_IntBrutoPago1Le," M.N.)} y los",
		  " siguientes {\\b ",Var_NumPagosReg," (",Var_NumPagosRegLet,")} pagos por valor de {\\b $",Var_MontoIntBrutoR,
		  " (",Var_MontoIntBrutoRL," M.N.)} cada uno, (menos la cantidad de ISR que las",
		  " autoridades hacendarias obliguen a La Financiera a retener y enterar) y serán pagaderos los días {\\b ",Var_DiaPagoInt,
		  " (",Var_DiaPagoIntLet,")} de cada mes iniciando el día {\\b ",Var_DiaPrimPagoInt," (",Var_DiaPrimPagoInttLet,")} de",
		  " {\\b ",Var_MesAnioPrimPago," (",Var_AnioPrimPagLetra,")} y el último el día {\\b ",Var_DiaVencimNum," (",Var_DiaVencimLetra,")} de ",
		  " {\\b ",Var_MesAnioVencim," (",Var_AnioLetraVencim,")}.");

        Set Var_CantNegrita := LENGTH( Var_TasaNum)+LENGTH( Var_TasaLetra)+11 + LENGTH(Var_NumPagos)+ LENGTH(Var_NumPagosLetra)+ 2 +
							LENGTH(Var_IntBrutoPago1)+LENGTH(Var_IntBrutoPago1Le)+6 +
                            LENGTH(Var_NumPagosReg)+LENGTH(Var_NumPagosRegLet)+2 +
                            LENGTH(Var_MontoIntBrutoR)+LENGTH(Var_MontoIntBrutoRL)+2 +
                            LENGTH(Var_DiaPagoInt)+LENGTH(Var_DiaPagoIntLet) + 2 +
                            LENGTH(Var_DiaPrimPagoInt)+LENGTH(Var_DiaPrimPagoInttLet) + 2 +
                            LENGTH(Var_MesAnioPrimPago)+LENGTH(Var_AnioPrimPagLetra) + 2 +
                            LENGTH(Var_DiaVencimNum)+LENGTH(Var_DiaVencimLetra) + 2 +
                            LENGTH(Var_MesAnioVencim)+LENGTH(Var_AnioLetraVencim) + 2 ;

        set Var_NumLineas:=0;
		set Var_LongLinea:=0;
		call CALCLINEASPRO(Var_Cadena,Var_CantNegrita,121,Var_LongLinea,Var_NumLineas,
					Aud_EmpresaID,Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,Aud_Sucursal,Aud_NumTransaccion);
		-- Fin para obtener el parrafo dinamico

		-- SELECT FINAL
		SELECT 	Var_NumRecibo,
				CAST(FORMAT(Var_MontoAport,2) AS CHAR) AS Var_MontoAport,
				CONCAT(Var_MontoAportLetra,'M.N.') AS Var_MontoAportLetra,
				FNFECHATEXTO(Var_FechaSuscrip) AS Var_FechaSuscrip,
				FNFECHATEXTO(Var_FechaVencim) AS Var_FechaVencim,
				CAST(Var_NumRegistro AS CHAR) AS Var_NumRegistro,
				Var_NombreAport,
				Var_RepLegalAport,
				Var_DiaVencimNum,
				RTRIM(Var_DiaVencimLetra) AS Var_DiaVencimLetra,
				Var_MesAnioVencim,
				RTRIM(Var_AnioLetraVencim) AS Var_AnioLetraVencim,
				CAST(Var_TasaNum AS CHAR) AS Var_TasaNum,
				Var_TasaLetra,
				Var_Representante,
				Var_DirecInstit,
				Var_TipoPersona,

				CAST(Var_NumPagos AS CHAR) AS Var_NumPagos,
				Var_NumPagosLetra,
				CAST(FORMAT(Var_IntBrutoPago1,2) AS CHAR) AS Var_IntBrutoPago1,
				Var_IntBrutoPago1Le,
				CAST(Var_NumPagosReg AS CHAR) AS Var_NumPagosReg,
				Var_NumPagosRegLet,
				CAST(FORMAT(Var_MontoIntBrutoR,2) AS CHAR) AS Var_MontoIntBrutoR,
				Var_MontoIntBrutoRL,
				CAST(Var_DiaPagoInt AS CHAR) AS Var_DiaPagoInt,
				Var_DiaPagoIntLet,
				CAST(Var_DiaPrimPagoInt AS CHAR) AS Var_DiaPrimPagoInt,
				Var_DiaPrimPagoInttLet,
				UPPER(Var_MesAnioPrimPago) AS Var_MesAnioPrimPago,
				Var_AnioPrimPagLetra,
                Var_CadEncFis,
                Var_NumLineasF,
				Var_LongLineaF,
                Var_NumLineas AS NumLineas,
                Var_LongLinea AS LongLinea,
                Var_Cadena AS Parrafo;
	END IF;

	-- SECCION PARA OBTENER LOS DATOS PARA EL REPORTE "RECIBO REGULAR MENSUAL"
	IF(Par_NumCon = Con_ReciboRegu)THEN

		-- Obteniendo valores a utilizar de la Aportacion
		SELECT	FechaInicio,FechaVencimiento, CuentaAhoID,AportacionID,Monto,ClienteID,TasaFija,DiasPago
				INTO Var_FechaSuscrip,Var_FechaVencim,Var_CuentaAhoID,Var_NumRecibo,Var_MontoAport,Var_NumRegistro,Var_TasaNum,Var_DiaPagoInt
				FROM 	APORTACIONES
				WHERE 	AportacionID	= Par_AportacionID;

		SET Var_MontoAport 		:= IFNULL(Var_MontoAport,Decimal_Cero);
		SET Var_MontoAportLetra := FUNCIONNUMLETRAS(Var_MontoAport);

		SET Var_FechaSuscrip	:= IFNULL(Var_FechaSuscrip,Fecha_Vacia);
		SET Var_TasaNum			:= IFNULL(Var_TasaNum,Decimal_Cero);
		SET Var_TasaLetra		:= FUNCIONNUMEROSLETRAS(Var_TasaNum);

		-- OBTENER DATOS DE LA FECHA DE VENCIMIENTO DE LA APORTACION
		SET Var_FechaVencim := IFNULL(Var_FechaVencim,Fecha_Vacia);
		SET Var_CuentaAhoID	  := IFNULL(Var_CuentaAhoID,Entero_Cero);

		SET Var_DiaVencimNum		:= DAY(Var_FechaVencim);
		SET Var_DiaVencimNum		:= IF(Var_DiaVencimNum<10,CONCAT(Cadena_Cero,Var_DiaVencimNum),Var_DiaVencimNum);
		SET Var_DiaVencimLetra		:= FUNCIONNUMEROSLETRAS(Var_DiaVencimNum);

		SET Var_MesAnioVencim		:= CONCAT(UPPER(FUNCIONMESNOMBRE(Var_FechaVencim)),' de ', YEAR(Var_FechaVencim));
		SET Var_AnioLetraVencim		:= FUNCIONNUMEROSLETRAS(YEAR(Var_FechaVencim));


		-- OBTENER EL TIPO DE PERSONA DEL CLIENTE
		SELECT	TipoPersona
				INTO Var_TipoPersona
				FROM 	CLIENTES
				WHERE 	ClienteID	= Par_ClienteID;

		-- OBTENER DATOS DEL CLIENTE
		SELECT	IF(Var_TipoPersona=Persona_Moral,cli.RazonSocial,cli.NombreCompleto)
			INTO Var_NombreAport
			FROM 	CLIENTES cli
			WHERE 	cli.ClienteID	= Par_ClienteID;


		-- OBTENER LOS DATOS DEL REPRESENTANTE LEGAL
		IF(Var_TipoPersona = Persona_Moral)THEN
			-- obtener nombre del representante legal
			SELECT NombreCompleto
				INTO Var_RepLegalAport
				FROM CUENTASPERSONA
				WHERE CuentaAhoID=Var_CuentaAhoID
				AND EsApoderado = Cons_SI
				ORDER BY PersonaID ASC
				LIMIT 1 ;
			SET Var_RepLegalAport := IFNULL(Var_RepLegalAport,Cadena_Vacia);

		ELSE
			SET Var_RepLegalAport	:= IFNULL(Var_RepLegalAport,Cadena_Vacia);
		END IF;

		-- OBTENER EL NOMBRE DEL REPRESENTANTE LEGAL DE LA FINANCIERA
		SET Var_Representante := (SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET Var_Representante := IFNULL(Var_Representante,Cadena_Vacia);

		SET Var_DirecInstit	  := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);

		-- OBTENER DATOS PARA CUOTAS DE LA APORTACION
		SET Var_NumPagos 		:= (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID);
		SET Var_NumPagosLetra	:= RTRIM(FUNCIONNUMEROSLETRAS(Var_NumPagos));

		SET Var_IntBrutoPago1 	:= (SELECT Interes FROM AMORTIZAAPORT WHERE AportacionID=Par_AportacionID LIMIT 1);
		SET Var_IntBrutoPago1Le	:= RTRIM(FUNCIONNUMLETRAS(Var_IntBrutoPago1));

		SET Var_DiaPagoIntLet 	:= RTRIM(FUNCIONNUMEROSLETRAS(Var_DiaPagoInt));

		SELECT DAY(FechaPago), CONCAT(FUNCIONMESNOMBRE(FechaPago),' ',YEAR(FechaPago)),RTRIM(FUNCIONNUMEROSLETRAS(YEAR(FechaPago)))
									INTO Var_DiaPrimPagoInt, Var_MesAnioPrimPago,Var_AnioPrimPagLetra
									FROM AMORTIZAAPORT
									WHERE AportacionID=Par_AportacionID
									AND AmortizacionID = Entero_Uno ;

		SET Var_DiaPrimPagoInttLet := RTRIM(FUNCIONNUMEROSLETRAS(Var_DiaPrimPagoInt));

		-- SELECT FINAL
		SELECT 	Var_NumRecibo,
				CAST(FORMAT(Var_MontoAport,2) AS CHAR) AS Var_MontoAport,
				CONCAT(Var_MontoAportLetra,'M.N.') AS Var_MontoAportLetra,
				FNFECHATEXTO(Var_FechaSuscrip) AS Var_FechaSuscrip,
				FNFECHATEXTO(Var_FechaVencim) AS Var_FechaVencim,
				CAST(Var_NumRegistro AS CHAR) AS Var_NumRegistro,
				Var_NombreAport,
				Var_RepLegalAport,
				Var_DiaVencimNum,
				RTRIM(Var_DiaVencimLetra) AS Var_DiaVencimLetra,
				Var_MesAnioVencim,
				RTRIM(Var_AnioLetraVencim) AS Var_AnioLetraVencim,
				CAST(Var_TasaNum AS CHAR) AS Var_TasaNum,
				Var_TasaLetra,
				Var_Representante,
				Var_DirecInstit,
				Var_TipoPersona,

				CAST(Var_NumPagos AS CHAR) AS Var_NumPagos,
				Var_NumPagosLetra,
				CAST(FORMAT(Var_IntBrutoPago1,2) AS CHAR) AS Var_IntBrutoPago1,
				Var_IntBrutoPago1Le,
				CAST(Var_DiaPagoInt AS CHAR) AS Var_DiaPagoInt,
				Var_DiaPagoIntLet,
				CAST(Var_DiaPrimPagoInt AS CHAR) AS Var_DiaPrimPagoInt,
				Var_DiaPrimPagoInttLet,
				UPPER(Var_MesAnioPrimPago) AS Var_MesAnioPrimPago,
				Var_AnioPrimPagLetra;
	END IF;


END TerminaStore$$
DELIMITER ;
