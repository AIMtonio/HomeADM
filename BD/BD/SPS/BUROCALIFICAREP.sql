-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTRENOVACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUROCALIFICAREP`;
DELIMITER $$


CREATE PROCEDURE `BUROCALIFICAREP`(
-- ==============================================================
-- ----- SP PARA GENERAR EL ARCHIVO LOTE PARA BURO CALIFICA -----
-- ==============================================================
	Par_Tipocartera			CHAR(1),		-- Tipo Cartera
	Par_RangoCartera		CHAR(1),		-- Rango de la cartera
	Par_Periodo				DATE,			-- Periodo de consulta
	Par_EstatusCredito		CHAR(1),		-- Estatus del Credito
	Par_Transaccion			BIGINT(12),		-- Numero de Transaccion

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATE,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria

	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_SentenciaCLI	VARCHAR(10000);	-- Sentencia SQL para obtener los Clientes
DECLARE Var_SentenciaAVA	VARCHAR(10000);	-- Sentencia SQL para obtener los Avales
DECLARE Var_SentenciaGAR	VARCHAR(10000);	-- Sentencia SQL para obtener los Garantes
DECLARE Var_FechaInicioMes	DATE;			-- Fecha de Inicio del mes del Par_Periodo
DECLARE Var_FechaFinMes		DATE;			-- Fecha de Fin del mes del Par_Periodo
DECLARE Var_ClienteID		INT(11);		-- ID del cliente
DECLARE Var_PaisResidencia	INT(11);		-- Codigo del pais de residencia
DECLARE Var_EstadoNombre	VARCHAR(150);	-- Nombre del estado de la direccion
DECLARE Var_Suma			DECIMAL(18,2);	-- Suma del total del adeudo de credito por cliente
DECLARE Var_TotalAdeudo		DECIMAL(12,2);	-- Total del adeudo
DECLARE Var_EstatusCred		CHAR(1);		-- Estatus del credito


-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia		VARCHAR(20);	-- Constante entero cero
DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante decimal cero
DECLARE Entero_Cero			TINYINT;		-- Cadena vacia
DECLARE Constante_NO		CHAR(1);		-- Constante NO
DECLARE Constante_SI		CHAR(1);		-- Constante SI
DECLARE Cartera_Micro		CHAR(1);		-- Cartera Micro
DECLARE Cartera_Agro		CHAR(1);		-- Cartera Agro
DECLARE Estatus_Vigente		CHAR(1);		-- Estatus Vigente
DECLARE Estatus_Atrasado	CHAR(1);		-- Estatus atrasado
DECLARE Estatus_Vencido		CHAR(1);		-- Estatus Vencido
DECLARE Estatus_Castigado	CHAR(1);		-- Estatus Castigado
DECLARE Persona_Fisica		CHAR(1);		-- Constante Persona Fisica
DECLARE Persona_Moral		CHAR(1);		-- Constante Persona Moral
DECLARE Total_Cartera		CHAR(1);		-- Constante Total de la cartera
DECLARE Cred_Periodo		CHAR(1);		-- Constante Creditos Nacidos en el periodo
DECLARE Per_FisAct			CHAR(1);		-- Constante para personas fisicas y con actividad empresarial, para este reporte es F
DECLARE Cons_Accionista		CHAR(1);		-- Constante Accionista
DECLARE Constante_Mexico	INT(11);		-- Constante ID del pais Mexico
DECLARE Cliente_Activo		CHAR(1);		-- Estatus del Cliente Activo
DECLARE BasePorcentaje		DECIMAL(12,2);	-- Base del Porcentaje del adeudo que se tomará en cuenta para el reporte
DECLARE Constante_Aval		INT(11);		-- Constante Aval
DECLARE Constante_Garante	INT(11);		-- Constante Garante
DECLARE Constante_Cliente	INT(11);		-- Constante Cliente
DECLARE Aval_Cliente		INT(11);		-- Aval tipo Cliente
DECLARE Aval_Prospecto		INT(11);		-- Aval tipo Prospecto


-- ASIGNACION  DE CONSTANTES
SET Cadena_Vacia			:= '';
SET Decimal_Cero			:= 00.00;
SET	Entero_Cero				:= 0;
SET Constante_NO			:= 'N';
SET Constante_SI			:= 'S';
SET Cartera_Micro			:= 'M';
SET Cartera_Agro			:= 'A';
SET Estatus_Vigente			:= 'V';
SET Estatus_Atrasado		:= 'A';
SET Estatus_Vencido			:= 'B';
SET Estatus_Castigado		:= 'K';
SET Persona_Fisica			:= 'F';
SET Persona_Moral			:= 'M';
SET Total_Cartera			:= 'T';
SET Cred_Periodo			:= 'P';
SET Per_FisAct				:= 'F';
SET Cons_Accionista			:= 'A';
SET Constante_Mexico		:= 700;
SET Cliente_Activo			:= 'A';
SET BasePorcentaje			:= 5.0;
SET Constante_Cliente		:= 1;
SET Constante_Aval			:= 2;
SET Constante_Garante		:= 3;
SET Aval_Cliente			:= 4;
SET Aval_Prospecto			:= 5;



SET Var_FechaFinMes := (SELECT LAST_DAY(Par_Periodo));
SET Var_FechaInicioMes := (SELECT STR_TO_DATE( CONCAT(YEAR(Par_Periodo), '-', MONTH(Par_Periodo), '-01'), '%Y-%m-%d'));
DELETE FROM TMPBUROCALIFICAREP WHERE Transaccion = Par_Transaccion;

-- =========================================== SENTENCIA PARA OBTENER LOS CLIENTES ===========================================
SET Var_SentenciaCLI := CONCAT(
	'INSERT IGNORE INTO TMPBUROCALIFICAREP(
		Transaccion,			ClienteID,				CreditoID,				EstatusCredito,			CuentaAhoID,
		TipoPersona,																					NombreCompleto,
		RazonSocial,			PrimerNombre,			SegundoNombre,			TercerNombre,			ApellidoPaterno,
		ApellidoMaterno,		RFCOficial,				Nacionalidad,			PaisNacimiento,			FechaNacimiento,
		CURP,					PaisResidencia,			TipoGarantiaFIRAID,		Clasificacion,
		TotalAdeudoCredito,
		EmpresaID,				Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion
	)SELECT ',
		Par_Transaccion,',		CLI.ClienteID,			CRE.CreditoID,			CRE.Estatus,			CRE.CuentaID,
		IF(CLI.TipoPersona = "', Persona_Moral, '", "', Persona_Moral ,'", "', Persona_Fisica ,'"),		CLI.NombreCompleto,
		CLI.RazonSocial,		CLI.PrimerNombre,		CLI.SegundoNombre,		CLI.TercerNombre,		CLI.ApellidoPaterno,
		CLI.ApellidoMaterno,	CLI.RFCOficial,			CLI.Nacion,				CLI.LugarNacimiento,	CLI.FechaNacimiento,
		CLI.CURP,				CLI.PaisResidencia,		CRE.TipoGarantiaFIRAID,	"', Constante_Cliente,'",
		SUM(CRE.SaldoCapVigent + CRE.SaldoCapAtrasad + CRE.SaldoCapVencido + CRE.SaldCapVenNoExi + CRE.SaldoInterOrdin +
		CRE.SaldoInterAtras + CRE.SaldoInterVenc + CRE.SaldoInterProvi), ',
		Par_EmpresaID,',',		Aud_Usuario,',"',		NOW(),'","', 			Aud_DireccionIP,'","',	Aud_ProgramaID,'",',
		Aud_Sucursal,',', 		Aud_NumTransaccion,' ',
		'FROM CLIENTES CLI
		 INNER JOIN CREDITOS CRE ON CLI.ClienteID = CRE.ClienteID
		 LEFT OUTER JOIN CATTIPOGARANTIAFIRA CAT ON CAT.TipoGarantiaID = CRE.TipoGarantiaFIRAID
		 WHERE CLI.Estatus = "', Cliente_Activo ,'" '
);




	IF(Par_Tipocartera = Cartera_Agro) THEN
		SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI, ' AND CRE.EsAgropecuario = "S" ');
	END IF;

	IF(Par_Tipocartera = Cartera_Micro) THEN
		SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI, ' AND CRE.EsAgropecuario = "N" ');
	END IF;

	IF(Par_RangoCartera = Cred_Periodo) THEN
		SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI, ' AND CRE.FechaInicio BETWEEN "', Var_FechaInicioMes, '" AND "', Var_FechaFinMes, '" ');
	END IF;



	IF(Par_EstatusCredito != Cadena_Vacia) THEN
		IF(Par_EstatusCredito = Estatus_Atrasado) THEN
			SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI,' AND CRE.Estatus IN ("', Estatus_Vigente ,'")  AND CRE.SaldoCapAtrasad > "', Decimal_Cero, '" ');
		ELSE
			IF (Par_EstatusCredito = Estatus_Vigente) THEN
				SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI,' AND CRE.Estatus IN ("', Estatus_Vigente ,'")  AND CRE.SaldoCapAtrasad = "', Decimal_Cero, '" ');
            ELSE
				SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI, ' AND CRE.Estatus = "', Par_EstatusCredito, '" ' );
            END IF;
		END IF;
	ELSE
		SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI, ' AND CRE.Estatus IN ("', Estatus_Vigente ,'", "', Estatus_Vencido ,'")');
	END IF;


	SET Var_SentenciaCLI :=  CONCAT(Var_SentenciaCLI,  ' GROUP BY CRE.CreditoID ;');

	SET @SentenciaClientes	= (Var_SentenciaCLI);

	PREPARE SPBUROCALIFICAREP FROM @SentenciaClientes;
	EXECUTE SPBUROCALIFICAREP;

	DEALLOCATE PREPARE SPBUROCALIFICAREP;



	SET @Consecutivo	:= 0;
	UPDATE TMPBUROCALIFICAREP TBC
	SET TBC.Consecutivo = (@Consecutivo := @Consecutivo+1)
    WHERE Transaccion = Par_Transaccion;

	UPDATE TMPBUROCALIFICAREP TBC
		INNER JOIN DIRECCLIENTE		DIR		ON TBC.ClienteID = DIR.ClienteID	AND IF(TBC.TipoPersona = Persona_Moral, (DIR.Fiscal = Constante_SI), (DIR.Oficial = Constante_SI))
		INNER JOIN ESTADOSREPUB		EST		ON DIR.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB	MUN		ON DIR.EstadoID = MUN.EstadoID		AND DIR.MunicipioID = MUN.MunicipioID
		INNER JOIN LOCALIDADREPUB	LOC		ON DIR.EstadoID = LOC.EstadoID		AND DIR.MunicipioID = LOC.MunicipioID	AND DIR.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL	ON DIR.EstadoID = COL.EstadoID		AND DIR.MunicipioID = COL.MunicipioID	AND DIR.ColoniaID = COL.ColoniaID
	SET TBC.NumeroExterior = DIR.NumeroCasa,
		TBC.NumeroInterior = DIR.NumInterior,
		TBC.Calle = DIR.Calle,
		TBC.Colonia = COL.Asentamiento,
		TBC.Municipio = MUN.Nombre,
		TBC.Ciudad = MUN.Nombre,
		TBC.Estado = EST.EqBuroCred,
		TBC.CodigoPostal = DIR.CP;



	SET @Contador		:= 1;
	SET @TotRegistros	:= (SELECT COUNT(CreditoID) FROM TMPBUROCALIFICAREP WHERE Transaccion = Par_Transaccion);

	-- INICIO CICLO WHILE
	WHILE @Contador <= @TotRegistros DO

		-- ======================= SE ACTUALIZA EL MONTO DEL TOTAL DE ADEUDO DE LOS CREDITOS VENCIDOS =======================
		SET Var_ClienteID := (SELECT ClienteID FROM TMPBUROCALIFICAREP WHERE Consecutivo = @Contador AND Transaccion = Par_Transaccion);
		SET Var_EstatusCred := (SELECT EstatusCredito FROM  TMPBUROCALIFICAREP WHERE Consecutivo = @Contador  AND Transaccion = Par_Transaccion);

		-- Se valida el estatus del credito
		IF (Var_EstatusCred = Estatus_Vencido)  THEN
			SET Var_TotalAdeudo := (SELECT TotalAdeudo FROM TMPBUROCALIFICAREP WHERE Consecutivo = @Contador  AND Transaccion = Par_Transaccion);
			SET Var_Suma := ( SELECT SUM(CRE.SaldoCapVigent + CRE.SaldoCapAtrasad + CRE.SaldoCapVencido + CRE.SaldCapVenNoExi + CRE.SaldoInterOrdin +
								    CRE.SaldoInterAtras + CRE.SaldoInterVenc + CRE.SaldoInterProvi) 
                                    FROM CREDITOS CRE  WHERE CRE.ClienteID = Var_ClienteID AND CRE.Estatus IN(Estatus_Vencido,Estatus_Vigente));

			IF(IFNULL(Var_TotalAdeudo, Cadena_Vacia) = Cadena_Vacia) THEN
				UPDATE TMPBUROCALIFICAREP TBC
				SET TBC.TotalAdeudo = Var_Suma
				WHERE TBC.ClienteID = Var_ClienteID AND Transaccion = Par_Transaccion;
			END IF;
		END IF;



		-- =============== SE ACTUALIZA LA DIRECCION DE LOS CLIENTES QUE NO TIENEN DIRECCION Y SON EXTRANJEROS ==============
		SET Var_PaisResidencia := (SELECT PaisResidencia FROM TMPBUROCALIFICAREP WHERE Consecutivo = @Contador  AND Transaccion = Par_Transaccion);
		SET Var_EstadoNombre := (SELECT Estado FROM TMPBUROCALIFICAREP WHERE Consecutivo = @Contador  AND Transaccion = Par_Transaccion);

		-- SE VALIDA SI NO TIENE DIRECCION
		IF(IFNULL(Var_EstadoNombre, Cadena_Vacia) = Cadena_Vacia) THEN
			-- SE VALIDA SI RESIDE EN EL EXTRANJERO
			IF(Var_PaisResidencia <> Constante_Mexico) THEN
				-- SI NO TIENE DIRECCION Y ES RESIDENTE EXTRANJERO, SE BUSCA DIRECCION EN LA TABLA CLIEXTRANJERO
				UPDATE TMPBUROCALIFICAREP TBC
					INNER JOIN CLIEXTRANJERO EXT
				SET TBC.Municipio = EXT.Localidad,
					TBC.Ciudad = EXT.Localidad,
					TBC.Estado = EXT.Entidad,
					TBC.CodigoPostal = EXT.Adi_CoPoEx
					WHERE TBC.ClienteID = EXT.ClienteID
					AND TBC.ClienteID = Var_ClienteID AND TBC.Transaccion = Par_Transaccion;
			END IF;
		END IF;
		SET @Contador := @Contador + 1 ;
	END WHILE;
	-- FIN CICLO WHILE


	-- Se actualizan los porcentajes de adeudo
	UPDATE TMPBUROCALIFICAREP TBC
	SET TBC.PorcentajeAdeudo = ((TBC.TotalAdeudoCredito * 100) / TotalAdeudo)
	WHERE TotalAdeudo > Decimal_Cero AND EstatusCredito = Estatus_Vencido
     AND TBC.Transaccion = Par_Transaccion;

	-- Se actualiza el estatus de los accionistas
	UPDATE TMPBUROCALIFICAREP T
	INNER JOIN CUENTASPERSONA C ON C.ClienteID = T.ClienteID
	SET TipoPersona = Cons_Accionista
	WHERE C.EsAccionista = Constante_SI AND C.EstatusRelacion = Estatus_Vigente
     AND T.Transaccion = Par_Transaccion;


	-- Se eliminan los creditos que no cumplan la condicion
	DELETE FROM TMPBUROCALIFICAREP
	WHERE PorcentajeAdeudo > BasePorcentaje
		AND EstatusCredito = Estatus_Vencido
		AND Transaccion = Par_Transaccion;





-- ============================================= SENTENCIA PARA OBTENER LOS AVALES ==========================================
	INSERT IGNORE INTO TMPBUROCALIFICAREP(
		Transaccion,			ClienteID,				Clasificacion,			CreditoID,				CuentaAhoID,
		TipoPersona,			NombreCompleto,			RazonSocial,			PrimerNombre,			SegundoNombre,
		TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		RFCOficial,				Nacionalidad,
		PaisNacimiento,			FechaNacimiento,		EmpresaID,				Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,			EstatusCredito
	)SELECT
		Par_Transaccion,		AVA.AvalID,				Constante_Aval,					CRE.CreditoID,			CRE.CuentaID,
		AVA.TipoPersona,		AVA.NombreCompleto,		AVA.RazonSocial,		AVA.PrimerNombre,		AVA.SegundoNombre,
		AVA.TercerNombre,		AVA.ApellidoPaterno,	AVA.ApellidoMaterno,	AVA.RFC,				AVA.Nacion,
		AVA.LugarNacimiento,	AVA.FechaNac,			Par_EmpresaID,			Aud_Usuario,			NOW(),
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,		CRE.Estatus
		FROM CREDITOS CRE
		INNER JOIN TMPBUROCALIFICAREP TMP ON TMP.CreditoID = CRE.CreditoID
		INNER JOIN AVALESPORSOLICI ASO ON ASO.SolicitudCreditoID = CRE.SolicitudCreditoID
		INNER JOIN AVALES AVA ON AVA.AvalID = ASO.AvalID
		WHERE TMP.Clasificacion = Constante_Cliente;



	UPDATE TMPBUROCALIFICAREP TMP
		INNER JOIN AVALES AVA ON AVA.AvalID = TMP.ClienteID
		INNER JOIN ESTADOSREPUB		EST		ON AVA.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB	MUN		ON AVA.EstadoID = MUN.EstadoID		AND AVA.MunicipioID = MUN.MunicipioID
		INNER JOIN LOCALIDADREPUB	LOC		ON AVA.EstadoID = LOC.EstadoID		AND AVA.MunicipioID = LOC.MunicipioID	AND AVA.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL	ON AVA.EstadoID = COL.EstadoID		AND AVA.MunicipioID = COL.MunicipioID	AND AVA.ColoniaID = COL.ColoniaID
	SET TMP.NumeroExterior = AVA.NumExterior,
		TMP.NumeroInterior = AVA.NumInterior,
		TMP.Calle = AVA.Calle,
		TMP.Colonia = COL.Asentamiento,
		TMP.Municipio = MUN.Nombre,
		TMP.Ciudad = MUN.Nombre,
		TMP.Estado = EST.EqBuroCred,
		TMP.CodigoPostal = AVA.CP
		WHERE TMP.Clasificacion = Constante_Aval
        AND TMP.Transaccion = Par_Transaccion;


-- =================================== SENTENCIA PARA OBTENER LOS AVALES QUE SON CLIENTES ===================================
	INSERT IGNORE INTO TMPBUROCALIFICAREP(
		Transaccion,			ClienteID,				Clasificacion,			CreditoID,				CuentaAhoID,
		TipoPersona,			NombreCompleto,			RazonSocial,			PrimerNombre,			SegundoNombre,
		TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		RFCOficial,				Nacionalidad,
		PaisNacimiento,			FechaNacimiento,		EmpresaID,				Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,			EstatusCredito
	)SELECT
		Par_Transaccion,		CLI.ClienteID,			Aval_Cliente,			CRE.CreditoID,			CRE.CuentaID,
		CLI.TipoPersona,		CLI.NombreCompleto,		CLI.RazonSocial,		CLI.PrimerNombre,		CLI.SegundoNombre,
		CLI.TercerNombre,		CLI.ApellidoPaterno,	CLI.ApellidoMaterno,	CLI.RFCOficial,			CLI.Nacion,
		CLI.LugarNacimiento,	CLI.FechaNacimiento,	Par_EmpresaID,			Aud_Usuario,			NOW(),
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,		CRE.Estatus
		FROM CREDITOS CRE
		INNER JOIN TMPBUROCALIFICAREP TMP ON TMP.CreditoID = CRE.CreditoID
		INNER JOIN AVALESPORSOLICI ASO ON ASO.SolicitudCreditoID = CRE.SolicitudCreditoID
		INNER JOIN CLIENTES CLI ON ASO.AvalID = CLI.ClienteID
		WHERE TMP.Clasificacion = Constante_Cliente;


		UPDATE TMPBUROCALIFICAREP TBC
		INNER JOIN DIRECCLIENTE		DIR		ON TBC.ClienteID = DIR.ClienteID	AND IF(TBC.TipoPersona = Persona_Moral, (DIR.Fiscal = Constante_SI), (DIR.Oficial = Constante_SI))
		INNER JOIN ESTADOSREPUB		EST		ON DIR.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB	MUN		ON DIR.EstadoID = MUN.EstadoID		AND DIR.MunicipioID = MUN.MunicipioID
		INNER JOIN LOCALIDADREPUB	LOC		ON DIR.EstadoID = LOC.EstadoID		AND DIR.MunicipioID = LOC.MunicipioID	AND DIR.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL	ON DIR.EstadoID = COL.EstadoID		AND DIR.MunicipioID = COL.MunicipioID	AND DIR.ColoniaID = COL.ColoniaID
	SET TBC.NumeroExterior = DIR.NumeroCasa,
		TBC.NumeroInterior = DIR.NumInterior,
		TBC.Calle = DIR.Calle,
		TBC.Colonia = COL.Asentamiento,
		TBC.Municipio = MUN.Nombre,
		TBC.Ciudad = MUN.Nombre,
		TBC.Estado = EST.EqBuroCred,
		TBC.CodigoPostal = DIR.CP
		WHERE TBC.Clasificacion = Aval_Cliente
        AND TBC.Transaccion = Par_Transaccion;


-- ================================== SENTENCIA PARA OBTENER LOS AVALES QUE SON PROSPECTOS ==================================
	INSERT IGNORE INTO TMPBUROCALIFICAREP(
		Transaccion,			ClienteID,				Clasificacion,			CreditoID,				CuentaAhoID,
		TipoPersona,			NombreCompleto,			RazonSocial,			PrimerNombre,			SegundoNombre,
		TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		RFCOficial,				Nacionalidad,
		PaisNacimiento,			FechaNacimiento,		EmpresaID,				Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,			EstatusCredito
	)SELECT
		Par_Transaccion,		PRO.ProspectoID,		Aval_Prospecto,			CRE.CreditoID,			CRE.CuentaID,
		PRO.TipoPersona,		PRO.NombreCompleto,		PRO.RazonSocial,		PRO.PrimerNombre,		PRO.SegundoNombre,
		PRO.TercerNombre,		PRO.ApellidoPaterno,	PRO.ApellidoMaterno,	IF(PRO.TipoPersona = Persona_Moral, PRO.RFCpm, PRO.RFC),		PRO.Nacion,
		PRO.LugarNacimiento,	PRO.FechaNacimiento,	Par_EmpresaID,			Aud_Usuario,			NOW(),
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,		CRE.Estatus
		FROM CREDITOS CRE
		INNER JOIN TMPBUROCALIFICAREP TMP ON TMP.CreditoID = CRE.CreditoID
		INNER JOIN AVALESPORSOLICI ASO ON ASO.SolicitudCreditoID = CRE.SolicitudCreditoID
		INNER JOIN PROSPECTOS PRO ON ASO.ProspectoID = PRO.ProspectoID
		WHERE TMP.Clasificacion = Constante_Cliente;



	UPDATE TMPBUROCALIFICAREP TMP
		INNER JOIN AVALES AVA ON AVA.AvalID = TMP.ClienteID
		INNER JOIN ESTADOSREPUB		EST		ON AVA.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB	MUN		ON AVA.EstadoID = MUN.EstadoID		AND AVA.MunicipioID = MUN.MunicipioID
		INNER JOIN LOCALIDADREPUB	LOC		ON AVA.EstadoID = LOC.EstadoID		AND AVA.MunicipioID = LOC.MunicipioID	AND AVA.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL	ON AVA.EstadoID = COL.EstadoID		AND AVA.MunicipioID = COL.MunicipioID	AND AVA.ColoniaID = COL.ColoniaID
	SET TMP.NumeroExterior = AVA.NumExterior,
		TMP.NumeroInterior = AVA.NumInterior,
		TMP.Calle = AVA.Calle,
		TMP.Colonia = COL.Asentamiento,
		TMP.Municipio = MUN.Nombre,
		TMP.Ciudad = MUN.Nombre,
		TMP.Estado = EST.EqBuroCred,
		TMP.CodigoPostal = AVA.CP
		WHERE TMP.Clasificacion = Aval_Prospecto
        AND TMP.Transaccion = Par_Transaccion;


-- ============================================ SENTENCIA PARA OBTENER LOS GARANTES =========================================
	INSERT IGNORE INTO TMPBUROCALIFICAREP(
		Transaccion,			ClienteID,				Clasificacion,			CreditoID,				CuentaAhoID,
		TipoPersona,			NombreCompleto,			RazonSocial,			PrimerNombre,			SegundoNombre,
		TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		RFCOficial,				Nacionalidad,
		PaisNacimiento,			FechaNacimiento,		EmpresaID,				Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,			EstatusCredito
	)SELECT
		Par_Transaccion,		T.GaranteID, 			Constante_Garante,		C.CreditoID, 			C.CuentaID,
		T.TipoPersona, 			T.NombreCompleto, 		T.RazonSocial, 			T.PrimerNombre, 		T.SegundoNombre,
		T.TercerNombre, 		T.ApellidoPaterno, 		T.ApellidoMaterno, 		T.RFCOficial, 			T.Nacion,
		T.LugarNacimiento, 		T.FechaNacimiento, 		Par_EmpresaID,			Aud_Usuario,			NOW(),
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,		C.Estatus
		FROM CREDITOS C
		INNER JOIN TMPBUROCALIFICAREP TMP ON TMP.CreditoID = C.CreditoID
		INNER JOIN ASIGNAGARANTIAS A ON A.SolicitudCreditoID = C.SolicitudCreditoID
		INNER JOIN GARANTIAS G ON G.GarantiaID = A.GarantiaID
		INNER JOIN GARANTES T ON T.GaranteID = G.GaranteID
		WHERE TMP.Clasificacion = Constante_Cliente;


	UPDATE TMPBUROCALIFICAREP TMP
		INNER JOIN GARANTES GAR ON GAR.GaranteID = TMP.ClienteID
		INNER JOIN ESTADOSREPUB		EST		ON GAR.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB	MUN		ON GAR.EstadoID = MUN.EstadoID		AND GAR.MunicipioID = MUN.MunicipioID
		INNER JOIN LOCALIDADREPUB	LOC		ON GAR.EstadoID = LOC.EstadoID		AND GAR.MunicipioID = LOC.MunicipioID	AND GAR.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL	ON GAR.EstadoID = COL.EstadoID		AND GAR.MunicipioID = COL.MunicipioID	AND GAR.ColoniaID = COL.ColoniaID
	SET TMP.NumeroExterior = GAR.NumeroCasa,
		TMP.NumeroInterior = GAR.NumInterior,
		TMP.Calle = GAR.Calle,
		TMP.Colonia = COL.Asentamiento,
		TMP.Municipio = MUN.Nombre,
		TMP.Ciudad = MUN.Nombre,
		TMP.Estado = EST.EqBuroCred,
		TMP.CodigoPostal = GAR.CP
	WHERE TMP.Clasificacion = Constante_Garante
    AND TMP.Transaccion = Par_Transaccion;



SELECT
	IFNULL(T.ClienteID, Cadena_Vacia) AS ClienteID,
	IFNULL(T.CreditoID, Cadena_Vacia) AS CreditoID,
	IFNULL(T.CuentaAhoID, Cadena_Vacia) AS CuentaAhoID,
	IFNULL(T.TipoPersona, Cadena_Vacia) AS TipoPersona,
	IF(T.TipoPersona = Persona_Moral, LEFT(T.RFCOficial, 12), LEFT (T.RFCOficial, 13) ) AS RFCOficial,
	IF(T.TipoPersona = Persona_Moral, T.RazonSocial, T.PrimerNombre) AS PrimerNombre,
	IFNULL(T.SegundoNombre, Cadena_Vacia) AS SegundoNombre,
	IFNULL(T.ApellidoPaterno, Cadena_Vacia) AS ApellidoPaterno,
	IF(T.TipoPersona = Cons_Accionista, IFNULL(T.ApellidoMaterno, Cadena_Vacia), Cadena_Vacia) AS ApellidoMaterno,
	IF(T.TipoPersona = Persona_Moral, Cadena_Vacia, T.FechaNacimiento) AS FechaNacimiento,
	IFNULL(T.CURP, Cadena_Vacia) AS CURP,
	LEFT(IFNULL(T.Calle,Cadena_Vacia), 40) AS Direccion,
	CONCAT(
		IF(IFNULL(T.NumeroExterior, Cadena_Vacia) = Cadena_Vacia, Cadena_Vacia, CONCAT('NUM. EXT. ',T.NumeroExterior)),
		IF(IFNULL(T.NumeroInterior, Cadena_Vacia) = Cadena_Vacia, Cadena_Vacia, CONCAT(', NUM. INT. ',T.NumeroInterior)) ) AS DireccionDOS,
	LEFT(IFNULL(T.Colonia, Cadena_Vacia), 40)  AS Colonia,
	LEFT(IFNULL(T.Municipio, Cadena_Vacia), 40) AS Municipio,
	LEFT(IFNULL(T.Ciudad, Cadena_Vacia), 40) AS Ciudad,
	LEFT(IFNULL(T.Estado, Cadena_Vacia), 40) AS Estado,
	IFNULL(T.CodigoPostal, Cadena_Vacia) AS CodigoPostal,
	IFNULL(T.PaisNacimiento, Cadena_Vacia) AS PaisNacimiento,
	IFNULL(P.EqBuroCred, Cadena_Vacia) AS PaisNombre
FROM TMPBUROCALIFICAREP T
INNER JOIN PAISES P ON P.PaisID = T.PaisNacimiento
WHERE T.Transaccion = Par_Transaccion
ORDER BY T.CreditoID;

DELETE FROM TMPBUROCALIFICAREP WHERE Transaccion = Par_Transaccion;
END TerminaStore$$