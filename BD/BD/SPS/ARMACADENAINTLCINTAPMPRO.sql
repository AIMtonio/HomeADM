-- ARMACADENAINTLCINTAPMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS ARMACADENAINTLCINTAPMPRO;
DELIMITER $$

CREATE PROCEDURE ARMACADENAINTLCINTAPMPRO(
	-- Descripcion: Proceso para armar la cadena INTL para el reporte de buro de credito de personas morales mensual
	-- Modulo: Buro de Credito(Cinta de Buro de Credito)
	Par_FechaCorteBC	DATE,			-- Fecha de Corte para generar el reporte

	Par_Salida			CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_CintaINTL			LONGTEXT;			-- Cinta en formato INTL
	DECLARE Var_HeaderINTL			LONGTEXT;			-- Variable para guardar el encabezado de la cinta
	DECLARE Var_EMINTL				LONGTEXT;			-- Variable para guardar los datos generales de la cinta
	DECLARE Var_AvalesINTL			LONGTEXT;			-- Variable para guardar los avales de la cinta de buro
	DECLARE Var_AccionistasINTL		LONGTEXT;			-- Variable para almacenar el segmento de directivos o accionistas
	DECLARE Var_Control				VARCHAR(50);		-- Variable de Control
	DECLARE Var_Contador			INT(11);			-- Variable para almacenar el contador
	DECLARE Var_Registros			INT(11);			-- Variable para almacenar el total de registros
	DECLARE Var_ClaveOtorgante		VARCHAR(20);		-- Clave del Otorgante
	DECLARE Var_NombreReporte		VARCHAR(40);		-- Nombre del Reporte
	DECLARE Var_RegistroAvales		INT(11);			-- Total de avales a iterar
	DECLARE Var_ContadorAval		INT(11);			-- Contador de avales
	DECLARE Var_RegistroDirectivos	INT(11);			-- Total de directivos a iterar
	DECLARE Var_ContadorDirectivos	INT(11);			-- Contador de directivos
	DECLARE Var_CreditoID			BIGINT(12);			-- Variable para almacenar el credito ID
	DECLARE Var_TotalSaldos			VARCHAR(20);		-- Variable para almacenar el total de saldos
	DECLARE Var_TotalRegistros		INT(11);			-- Variable para almacenar el total de registros

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante cadena vacia ''
	DECLARE Con_NO					CHAR(1);			-- Constante NO
	DECLARE Con_SI					CHAR(1);			-- Constante SI
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);			-- Constantes de entero uno
	DECLARE FormatoFecha			VARCHAR(10);		-- Formato de Fecha
	DECLARE Fecha_Vacia 			DATE;				-- Constante Fecha Vacia
	DECLARE Con_Nacional			CHAR(2);			-- Codigo nacionalidad mexicana
	DECLARE Entero_Dos				INT(11);			-- Entero dos

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Con_NO						:= 'N';
	SET Con_SI						:= 'S';
	SET FormatoFecha				:= '%d%m%Y';
	SET Fecha_Vacia	 				:= '1900-01-01';
	SET Con_Nacional				:= 'MX';
	SET Entero_Cero					:= 0;
	SET Entero_Uno					:= 1;
	SET Entero_Dos					:= 2;

	-- Datos de la cinta
	SET Var_CintaINTL	 			:= Cadena_Vacia;
	SET Var_HeaderINTL	 			:= Cadena_Vacia;
	SET Var_EMINTL		 			:= Cadena_Vacia;
	SET Var_AvalesINTL				:= Cadena_Vacia;
	SET Var_AccionistasINTL			:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									'esto le ocasiona. Ref: SP-ARMACADENAINTLCINTAPMPRO');
			SET Var_Control = 'sqlException';
		END;

		-- SE OBTIENE LA CLAVE DEL OTORGANTE PARA ARMAR EL NOMBRE DEL ARCHIVO GENERADO
		SELECT	ClaveInstitID
		INTO	Var_ClaveOtorgante
		FROM BUCREPARAMETROS;

		-- SE ARMA EL NOMBRE DEL REPORTE A GENERAR
		SET Var_NombreReporte := CONCAT(IFNULL(Var_ClaveOtorgante,Cadena_Vacia),'_',DATE_FORMAT(IFNULL(Par_FechaCorteBC,Fecha_Vacia),FormatoFecha));
		SET Var_NombreReporte := IFNULL(Var_NombreReporte,Cadena_Vacia);

		-- !!! IMPORTANTE ¡¡¡
		-- NO CAMBIAR LAS ETIQUETAS INICIALES DE CADA CAMPO SIN CONSULTAR EL MANUAL CORRESPONDIENTE DE BURO DE CREDITO

		SELECT	CONCAT(	'HD',Identificador,					'00',LEFT(LPAD(ClaveUsuarioBC,4,0),4),	'01',LEFT(LPAD(ClaveUsuarioAntBC,4,0),4),	'02',LEFT(LPAD(TipoInstitucion,3,0),3),			'03',Formato,
						'04',LEFT(RPAD(Fecha,8,' '),8),		'05',LEFT(LPAD(Periodo,6,0),6),			'06',VersionINTL,							'07',LEFT(RPAD(NombreOtorgante,75, ' '),75),	'08',LEFT(RPAD(Filler,52, ' '),52)
						)
		INTO	Var_HeaderINTL
		FROM HEADERCADENAINTLCINTA
		WHERE NumTransaccion = Aud_NumTransaccion;

		-- Se inicia el contador en UNO
		SET Var_Contador := Entero_Uno;
		-- Se cuentan los registros totales a procesar de la tabla pivote
		SET Var_Registros 		:= (SELECT MAX(ID) FROM TMPDATOSEM);
		SET Var_TotalRegistros	:= (SELECT COUNT(ID) FROM TMPDATOSEM);
		SET Var_TotalSaldos		:= (SELECT CAST(SUM(Saldo) AS UNSIGNED) FROM TMPDATOSEM);

		-- SE LIMPIA EL CAMPO DE INTERES DE CREDITOS Y SE REALIZAN UPDATES
		UPDATE TMPDATOSEM
			SET
				InteresCred	= SUBSTRING_INDEX(InteresCred,'.',1),
				NumReportes	= Var_TotalRegistros,
				TotalSaldos	= Var_TotalSaldos;

		WHILE(Var_Contador <= Var_Registros) DO
			CicloCintaINTL:BEGIN
				-- INICIALIZACION DE CONTADORES Y VARIABLES
				SET Var_ContadorAval 		:= Entero_Uno;
				SET Var_ContadorDirectivos 	:= Entero_Uno;
				SET Var_RegistroAvales		:= Entero_Cero;
				SET Var_RegistroDirectivos	:= Entero_Cero;

				-- SE OBTIENE EL CREDITO ID
				SET Var_CreditoID := Entero_Cero;
				SET Var_CreditoID := (SELECT CreditoID FROM TMPDATOSEM WHERE ID = Var_Contador);
				SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);

				IF(Var_CreditoID = Entero_Cero)THEN
					LEAVE CicloCintaINTL;
				END IF;

				-- SE ACTUALIZA EL CICLO POR CREDITO
				UPDATE TMPAVALESLISTA SET CicloAvID = Entero_Cero;
				SET @AvalID := Entero_Cero;
				UPDATE TMPAVALESLISTA
					SET CicloAvID = (@AvalID := @AvalID + Entero_Uno)
				WHERE CredID = Var_CreditoID;

				-- SE ACTUALIZA LA TABLA DE ACCIONISTAS POR CREDIDO
				UPDATE TMPDIRECTIVOSLISTA SET CicloAcID = Entero_Cero;
				SET @AcionistaID := Entero_Cero;
				UPDATE TMPDIRECTIVOSLISTA
					SET CicloAcID = (@AcionistaID := @AcionistaID + Entero_Uno)
				WHERE CreditoID = Var_CreditoID;

				-- TOTAL DE AVALES A ITERAR POR CREDITO
				SET Var_RegistroAvales		:= (SELECT MAX(CicloAvID) FROM TMPAVALESLISTA WHERE CredID = Var_CreditoID);
				-- TOTAL DE DIRECTIVOS A ITERAR
				SET Var_RegistroDirectivos	:= (SELECT MAX(CicloAcID) FROM TMPDIRECTIVOSLISTA WHERE CreditoID = Var_CreditoID);

				-- SE INICIALIZA LOS AVALES  Y ACCIONISTAS POR CADA CICLO
				SET Var_AvalesINTL 		:= Cadena_Vacia;
				SET Var_AccionistasINTL	:= Cadena_Vacia;

				-- Se obtiene los avales
				-- SEGMENTO DE AVALES POR CADA CREDITO
				WHILE(Var_ContadorAval <= Var_RegistroAvales) DO
					SELECT	CONCAT(Var_AvalesINTL,
						'AV',IFNULL(Ava.IdentificaAV,'AV'),										'00',LEFT(RPAD(IFNULL(Ava.RFCAV,Cadena_Vacia),13,' '),13),				'01',LEFT(RPAD(IFNULL(Ava.CURPAV,Cadena_Vacia),18,' '),18),
						'02',LEFT(RPAD('',10, 0),10),											'03',LEFT(RPAD(IFNULL(Ava.CompaniaAV,Cadena_Vacia),150,' '),150),		'04',LEFT(RPAD(IFNULL(Ava.PrimerNombreAV,Cadena_Vacia),30,' '),30),
						'05',LEFT(RPAD(IFNULL(Ava.SegundoNombreAV,Cadena_Vacia),30,' '),30),	'06',LEFT(RPAD(IFNULL(Ava.ApePaternoAV,Cadena_Vacia),25,' '),25),		'07',LEFT(RPAD(IFNULL(Ava.ApeMaternoAV,Cadena_Vacia),25,' '),25),
						'08',LEFT(RPAD(IFNULL(Ava.PriLinDireccionAV,Cadena_Vacia),40,' '),40),	'09',LEFT(RPAD(IFNULL(Ava.SegLinDireccionAV,Cadena_Vacia),40,' '),40),	'10',LEFT(RPAD(IFNULL(Ava.ColoniaAV,Cadena_Vacia),60,' '),60),
						'11',LEFT(RPAD(IFNULL(Ava.MunicipioAV,Cadena_Vacia),40,' '),40),		'12',LEFT(RPAD(IFNULL(Ava.CiudadAV,Cadena_Vacia),40,' '),40),			'13',LEFT(RPAD(IFNULL(Ava.EstadoAV,Cadena_Vacia),4,' '),4),
						'14',LEFT(LPAD(IFNULL(Ava.CPAV,Cadena_Vacia),10,0),10),					'15',LEFT(RPAD(IFNULL(Ava.TelefonoAV,Cadena_Vacia),11,' '),11),			'16',LEFT(RPAD(IFNULL(Ava.ExtTelefonoAV,Cadena_Vacia),8,' '),8),
						'17',LEFT(LPAD(IFNULL(Ava.FaxAV,Cadena_Vacia),11,' '),11),				'18',LEFT(RPAD(IFNULL(Ava.TipoClienteAV,Cadena_Vacia),1,' '),1),		'19',LEFT(RPAD(IFNULL(Ava.EdoExtranjeroAV,Cadena_Vacia),40,' '),40),
						'20',LEFT(RPAD(IFNULL(Ava.PaisAV,Cadena_Vacia),2,' '),2),				'21',LEFT(RPAD('',94, ' '),94)
						)
					INTO Var_AvalesINTL
					FROM TMPAVALESLISTA Ava
					WHERE CicloAvID = Var_ContadorAval;

					SET Var_AvalesINTL 	:= IFNULL(Var_AvalesINTL, Cadena_Vacia);

					-- SE INCREMENTA EL CONTADOR DE AVALES
					SET Var_ContadorAval := Var_ContadorAval + Entero_Uno;
				END WHILE;

				-- SEGMENTO DE DIRECTIVOS O ACCIONISTAS
				WHILE(Var_ContadorDirectivos <= Var_RegistroDirectivos) DO
					SELECT CONCAT(Var_AccionistasINTL,
						'AC',IFNULL(Dir.IdentificaAC,'AC'),										'00',LEFT(RPAD(IFNULL(Dir.RFCAC,Cadena_Vacia),13,' '),13),				'01',LEFT(RPAD(IFNULL(Dir.CURPAC, Cadena_Vacia),18,' '),18),
						'02',LEFT(RPAD('0',10,0),10),											'03',LEFT(RPAD(IFNULL(Dir.CompaniaAC,Cadena_Vacia),150,' '),150),		'04',LEFT(RPAD(IFNULL(Dir.PrimerNombreAC,Cadena_Vacia),30,' '),30),
						'05',LEFT(RPAD(IFNULL(Dir.SegundoNombreAC,Cadena_Vacia),30,' '),30),	'06',LEFT(RPAD(IFNULL(Dir.ApePaternoAC,Cadena_Vacia),25,' '),25),		'07',LEFT(RPAD(IFNULL(Dir.ApeMaternoAC,Cadena_Vacia),25,' '),25),
						'08',LEFT(RPAD(IFNULL(Dir.PorcentajeAC,Cadena_Vacia),2,0),2),			'09',LEFT(RPAD(IFNULL(Dir.PriLinDireccionAC,Cadena_Vacia),40,' '),40),	'10',LEFT(RPAD(IFNULL(Dir.SegLinDireccionAC,Cadena_Vacia),40,' '),40),
						'11',LEFT(RPAD(IFNULL(Dir.ColoniaAC,Cadena_Vacia),60,' '),60),			'12',LEFT(RPAD(IFNULL(Dir.MunicipioAC,Cadena_Vacia),40,' '),40),		'13',LEFT(RPAD(IFNULL(Dir.CiudadAC,Cadena_Vacia),40,' '),40),
						'14',LEFT(RPAD(IFNULL(Dir.EstadoAC,Cadena_Vacia),4,' '),4),				'15',LEFT(LPAD(IFNULL(Dir.CPAC,Cadena_Vacia),10,0),10),					'16',LEFT(RPAD(IFNULL(Dir.TelefonoAC,Cadena_Vacia),11,' '),11),
						'17',LEFT(RPAD(IFNULL(Dir.ExtTelefonoAC,Cadena_Vacia),8,' '),8),		'18',LEFT(RPAD(IFNULL(Dir.FaxAC,Cadena_Vacia),11,' '),11),				'19',LEFT(RPAD(IFNULL(Dir.TipoClienteAC,Cadena_Vacia),1,' '),1),
						'20',LEFT(RPAD(IFNULL(Dir.EdoExtranjeroAC,Cadena_Vacia),40,' '),40),	'21',Con_Nacional,														'22',LEFT(RPAD('',40, ' '),40)
					)
					INTO Var_AccionistasINTL
					FROM TMPDIRECTIVOSLISTA Dir
					WHERE CicloAcID = Var_ContadorDirectivos;

					SET Var_AccionistasINTL := IFNULL(Var_AccionistasINTL, Cadena_Vacia);

					-- SE INCREMENTA EL CONTADOR DE DIRECTIVOS
					SET Var_ContadorDirectivos := Var_ContadorDirectivos + Entero_Uno;
				END WHILE;

				SET Var_AccionistasINTL	:= IFNULL(Var_AccionistasINTL, Cadena_Vacia);
				-- VALIDACION EN CASO DE NO TENER AVALES
				SET Var_AvalesINTL		:= IFNULL(Var_AvalesINTL, Cadena_Vacia);

				-- SEGMENTO DE DATOS GENERALES DE LA CINTA
				SELECT	CONCAT(
					'EM',IFNULL(IdentificaEM,'EM'),												'00',LEFT(RPAD(IFNULL(RFC,Cadena_Vacia),13,' '), 13),					'01',LEFT(RPAD(IFNULL(CURP,Cadena_Vacia),18,' '),18),		'02',RPAD('0',10,'0'),
					'03',LEFT(RPAD(IFNULL(Compania,Cadena_Vacia),150, ' '),150),				'04',LEFT(RPAD(IFNULL(PrimerNombre,Cadena_Vacia),30,' '),30),			'05',LEFT(RPAD(IFNULL(SegundoNombre,Cadena_Vacia),30,' '),30),
					'06',LEFT(RPAD(IFNULL(ApePaterno,Cadena_Vacia),25,' '),25),					'07',LEFT(RPAD(IFNULL(ApeMaterno,Cadena_Vacia),25,' '),25),				'08',Con_Nacional,
					'09',LEFT(RPAD(IFNULL(CalifCartera,Cadena_Vacia),2,' '),2),					'10',LEFT(LPAD(IFNULL(ActEconomica1,Cadena_Vacia),11,0),11),			'11',LEFT(LPAD(IFNULL(ActEconomica2,Cadena_Vacia),11,0),11),
					'12',LEFT(LPAD(IFNULL(ActEconomica3,Cadena_Vacia),11,0),11),				'13',LEFT(RPAD(IFNULL(PriLinDireccion,Cadena_Vacia),40,' '),40),		'14',LEFT(RPAD(IFNULL(SegLinDireccion,Cadena_Vacia),40, ' '),40),
					'15',LEFT(RPAD(IFNULL(Colonia,Cadena_Vacia),60, ' '),60),					'16',LEFT(RPAD(IFNULL(Municipio,Cadena_Vacia),40, ' '),40),				'17',LEFT(RPAD(IFNULL(Ciudad,Cadena_Vacia),40,' '),40),
					'18',LEFT(RPAD(IFNULL(Estado,Cadena_Vacia),4,' '),4),						'19',LEFT(LPAD(IFNULL(CP,Cadena_Vacia),10,0),10),						'20',LEFT(RPAD(IFNULL(Telefono,Cadena_Vacia),11,' '),11),
					'21',LEFT(LPAD(IFNULL(ExtTelefono,Cadena_Vacia),8,' '),8),					'22',LEFT(LPAD(IFNULL(Fax,Cadena_Vacia),11,' '),11),					'23',IFNULL(TipoCliente,Cadena_Vacia),
					'24',LEFT(RPAD(IFNULL(EdoExtranjero,Cadena_Vacia),40,' '),40),				'25',Con_Nacional,														'26',LEFT(RPAD(IFNULL(ClaveConsolida,Cadena_Vacia),8,' '),8),
					'27',LEFT(RPAD('',87, ' '),87),
					IF(TipoCliente = Entero_Uno, Var_AccionistasINTL, Cadena_Vacia),
					'CR',IFNULL(IdentificaCR,'CR'),												'00',LEFT(RPAD(IFNULL(RFCCR,Cadena_Vacia),13,' '),13),					'01',LEFT(RPAD(IFNULL(NumExpeCred,Cadena_Vacia),6,0),6),
					'02',LEFT(LPAD(IFNULL(ContratoCR,Cadena_Vacia),25,0),25),					'03',LEFT(RPAD(IFNULL(CreditoIDAnt,Cadena_Vacia),25,0),25),				'04',LEFT(RPAD(IFNULL(FechaInicio,Cadena_Vacia),8,' '),8),
					'05',LEFT(LPAD(IFNULL(Plazo,Cadena_Vacia),6,0),6),							'06',LEFT(RPAD(IFNULL(TipoCredito,Cadena_Vacia),4,' '),4),				'07',LEFT(LPAD(IFNULL(SaldoInicial,Cadena_Vacia),20,0),20),
					'08',IFNULL(Moneda,Cadena_Vacia),											'09',LEFT(LPAD(IFNULL(NumPagos,Cadena_Vacia),4,0),4),					'10',LEFT(LPAD(IFNULL(FrecuenciaPag,Cadena_Vacia),5,0),5),
					'11',LEFT(LPAD(IFNULL(ImportePago,Cadena_Vacia),20,0),20),					'12',LEFT(RPAD(IFNULL(FechaUltPago,Cadena_Vacia),8,' '),8),				'13',LEFT(RPAD(IFNULL(FechaReestru,Cadena_Vacia),8,' '),8),
					'14',LEFT(LPAD(IFNULL(PagoEfectivo,Cadena_Vacia),20,0),20),					'15',LEFT(RPAD(IFNULL(FechaLiquida,Cadena_Vacia),8,' '),8),				'16',LEFT(LPAD(ROUND(IFNULL(Quita,Cadena_Vacia),Entero_Cero),20,0),20),
					'17',LEFT(LPAD(IFNULL(Dacion,Cadena_Vacia),20,0),20),						'18',LEFT(LPAD(IFNULL(Quebranto,Cadena_Vacia),20,0),20),				'19',LEFT(RPAD(IFNULL(ClaveObserva,Cadena_Vacia),4,' '),4),
					'20',LEFT(RPAD(IFNULL(CredEspecial,Cadena_Vacia),1,' '),1),					'21',LEFT(RPAD(IFNULL(FechaPrimerIn,Cadena_Vacia),8,' '),8),			'22',LEFT(LPAD(IFNULL(SaldoInsoluto,Cadena_Vacia),20,0),20),
					'23',LEFT(LPAD(CAST(IFNULL(CredMaxUti,Entero_Cero) AS UNSIGNED),20,0),20),	'24',LEFT(RPAD(IFNULL(FechIngCarVen,Cadena_Vacia),8,' '),8),			'25',LEFT(RPAD('',40, ' '),40),
					'DE',IFNULL(IdentificaDE,'DE'),												'00',LEFT(RPAD(IFNULL(RFCDE,Cadena_Vacia),13,' '),13),					'01',LEFT(LPAD(IFNULL(Contrato,Cadena_Vacia),25,0),25),
					'02',LEFT(LPAD(IFNULL(DiasVencido,Cadena_Vacia),3,0),3),					'03',LEFT(LPAD(IFNULL(Saldo,Cadena_Vacia),20,0),20),					'04',LEFT(LPAD(SUBSTRING_INDEX(IFNULL(InteresCred,Cadena_Vacia),'.',1),20,0),20),
					'05',LEFT(RPAD('',53, ' '),53),
					Var_AvalesINTL,
					IF(Var_Contador = Var_Registros,
						CONCAT('TS','TS',														'00',LEFT(LPAD(IFNULL(NumReportes,Cadena_Vacia),7,0),7),				'01',LEFT(LPAD(IFNULL(TotalSaldos,Cadena_Vacia),30,0),30),
						'02',LEFT(RPAD('',53, ' '),53)
						),
					Cadena_Vacia)
					)
				INTO Var_EMINTL
				FROM TMPDATOSEM Dat
				WHERE ID = Var_Contador;

				-- Se concadena la variable de datos generales a la cinta base
				SET Var_CintaINTL := CONCAT(Var_CintaINTL, Var_EMINTL);

				-- SE ACTUALIZA LA CADENA INTL, CONFORMADO POR EL HEADER Y LOS DATOS GENERALES
				UPDATE TMPDATOSEM
					SET
						HeaderINTL	= Var_HeaderINTL,
						Cinta		= Var_CintaINTL
				WHERE ID = Var_Contador;

				-- INICIALIZACION DE DATOS PARA EL CICLO
				SET Var_EMINTL 			:= Cadena_Vacia;
				SET Var_AvalesINTL		:= Cadena_Vacia;
				SET Var_CintaINTL		:= Cadena_Vacia;
			END CicloCintaINTL;
			-- SE INCREMENTA EL CONTADOR
			SET Var_Contador := Var_Contador + Entero_Uno;
		END WHILE;

		SELECT	Var_NombreReporte AS NombreArchivoCinta,	HeaderINTL,	Cinta
		FROM TMPDATOSEM;

		SET	Par_NumErr		:= Entero_Cero;
		SET Var_Control		:= 'cintaBCID';
		SET	Par_ErrMen		:= 'Reporte Generado de Forma Exitosa.';

	END ManejoErrores;
	-- Fin del manejador de errores.

	-- Se borran los registros de la tabla
	DELETE FROM HEADERCADENAINTLCINTA WHERE NumTransaccion = Aud_NumTransaccion;

	IF(Par_Salida = Con_SI) THEN
	 	SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;
END TerminaStore$$