-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMISIONNOTICOBREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMISIONNOTICOBREP`;DELIMITER $$

CREATE PROCEDURE `EMISIONNOTICOBREP`(
	/* SP DE REPORTES DE EMISION DE NOTIFICACIONES DE COBRANZA  */
    Par_CreditoID		BIGINT(12),				-- ID de del credito
	Par_FormatoID		INT(11),				-- ID del formato de notificacion que se genera de la tabla FORMATONOTIFICACOB
    Par_FechaSis		DATE,					-- Fecha del sistema
    Par_AvalID			BIGINT(20),				-- ID de aval
    Par_AvalClienteID	INT(11),				-- ID cliente del aval

	Par_EmpresaID		INT(11),				-- Parametros de auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables

	DECLARE	FechaSist			DATE;
	DECLARE Var_Sentencia		VARCHAR(6000);	-- Sentencia SQL
    DECLARE Var_NumPagosVen		INT(11);
    DECLARE Var_FechaAtrasadaP	DATE;
    DECLARE Var_TipoFormaNoti	CHAR(1);

	-- Declaracion de constantes
    DECLARE Rep_NotiAboVen		INT(11);
    DECLARE Rep_ReqPago			INT(11);
    DECLARE Rep_Formato3		INT(11);
    DECLARE Rep_ReqPagoAval		INT(11);
    DECLARE Rep_NotiCob			INT(11);

    DECLARE Rep_ExtJudAval		INT(11);
    DECLARE Rep_ExtJudDeu		INT(11);
    DECLARE Rep_ExcluSocio		INT(11);
    DECLARE Rep_RecordPago		INT(11);

	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);
	DECLARE Est_Atrasado		CHAR(15);

    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Cons_Si				CHAR(1);
    DECLARE Cons_No				CHAR(1);
    DECLARE Fecha_Vacia			DATE;
    DECLARE Tipo_FormatoAval	CHAR(1);

    -- Asignacion de constantes

    SET Rep_NotiAboVen		:= 1; 			-- NOTIFICACION DE ABONO VENCIDO
    SET Rep_ReqPago			:= 2; 			-- REQUERIMIENTO DE PAGO
    SET Rep_Formato3		:= 3;			-- FORMATO3
    SET Rep_ReqPagoAval		:= 4; 			-- REQUERIMIENTO DE PAGO DE AVAL
    SET Rep_NotiCob			:= 5; 			-- NOTIFICACION DE COBRANZA

    SET Rep_ExtJudAval		:= 6;			-- ETAPA EXTRAJUDICIAL CARTA AVAL
    SET Rep_ExtJudDeu		:= 7;			-- ETAPA EXTRAJUDICIAL CARTA DEUDOR PRINCIPAL
    SET Rep_ExcluSocio		:= 8;			-- CARTA DE EXCLUSION DE SOCIO
    SET Rep_RecordPago		:= 9;			-- RECORDATORIO DE PAGO

	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';
	SET Est_VencidoDes			:= 'VENCIDO';
    SET Est_Atrasado			:= 'A';

    SET Entero_Cero				:= 0;
    SET Cadena_Vacia			:= '';
    SET Cons_Si					:= 'S';
    SET Cons_No					:= 'N';
    SET Fecha_Vacia				:= '1900-01-01';
    SET Tipo_FormatoAval		:= 'A';


	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

	/*TABLA TEMPORAL REPORTE NOTFICACION */
		DROP TABLE IF EXISTS TMPREPORTENOTIFICA;
		CREATE TEMPORARY TABLE TMPREPORTENOTIFICA(
			CreditoID			BIGINT(12),
            UsuarioID			INT(11),
            SucursalID			INT(11),
            FechaCita			DATE,
            HoraCita			VARCHAR(10),

            ClienteID			INT(11),
            NombreCompleto		VARCHAR(200),
            DireccionCompleta	VARCHAR(500),
            DescripcionDirec	VARCHAR(200),
            NombreSucursal		VARCHAR(200),

            EstadoSucursal		VARCHAR(100),
            NumPagoVencidos		INT(11),
            Telefono			VARCHAR(20),
            NombreCompUsu		VARCHAR(200),
            NombreGerente		VARCHAR(200),

            DireccionSucursal	VARCHAR(250),
            TotalExigibleDia	DECIMAL(16,2),
            TotalAdeudoLiqui	DECIMAL(16,2),
            FechaAtrasadaPago	DATE
            );


		INSERT INTO TMPREPORTENOTIFICA(
					CreditoID,     		UsuarioID,            	SucursalID,				FechaCita,     			HoraCita,
					ClienteID,   		NombreCompleto,			DireccionCompleta,		DescripcionDirec

		)SELECT 	enc.CreditoID,		enc.UsuarioID,			enc.SucursalUsuID,		enc.FechaCita,			enc.HoraCita,
					cre.ClienteID,		cli.NombreCompleto,		dir.DireccionCompleta,	dir.Descripcion

        FROM EMISIONNOTICOB enc
			INNER JOIN CREDITOS cre
				ON enc.CreditoID = cre.CreditoID
			INNER JOIN CLIENTES cli
				ON cre.ClienteID = cli.ClienteID
			INNER JOIN DIRECCLIENTE dir
				ON cli.ClienteID = dir.ClienteID AND dir.Oficial = Cons_Si
		WHERE enc.CreditoID = Par_CreditoID
			AND enc.FechaEmision = Par_FechaSis
            AND enc.FormatoID = Par_FormatoID;

		-- ACTULIAZAR LOS DATOS DE LA SUCURSAL

		UPDATE TMPREPORTENOTIFICA tmp, SUCURSALES suc, ESTADOSREPUB est SET
			tmp.NombreSucursal =  suc.NombreSucurs,
            tmp.EstadoSucursal =  est.Nombre,
            tmp.Telefono 	   =  suc.Telefono,
            tmp.DireccionSucursal = suc.DirecCompleta
		WHERE tmp.SucursalID = suc.SucursalID
			AND suc.EstadoID = est.EstadoID;

		-- ACTUALIZAR EL NUMERO DE PAGOS VENCIDOS
        SET Var_NumPagosVen := (SELECT COUNT(AmortizacionID) FROM AMORTICREDITO
								WHERE CreditoID = Par_CreditoID AND FechaVencim <= Par_FechaSis AND Estatus IN(Est_Atrasado,Est_Vencido));

        UPDATE TMPREPORTENOTIFICA tmp SET
			tmp.NumPagoVencidos = Var_NumPagosVen
		WHERE tmp.CreditoID = Par_CreditoID;

        -- ACTUALIZAR DATOS DEL USUARIO
        UPDATE TMPREPORTENOTIFICA tmp, USUARIOS usu SET
			tmp.NombreCompUsu = usu.NombreCompleto
		WHERE  tmp.UsuarioID = usu.UsuarioID;

        -- ACTUALIZAR EL NOMBRE DEL GERENTE DE LA SUCURSAL
        UPDATE TMPREPORTENOTIFICA tmp, SUCURSALES suc, USUARIOS usu SET
			tmp.NombreGerente = usu.NombreCompleto
		WHERE  tmp.SucursalID = suc.SucursalID
			AND suc.NombreGerente = usu.UsuarioID;


        -- ACTUALIZAR DATOS DEL TOTAL EXIGIBLE  DEL CREDITO
        UPDATE TMPREPORTENOTIFICA tmp  SET
			tmp.TotalExigibleDia = FUNCIONEXIGIBLE(tmp.CreditoID)
		WHERE tmp.CreditoID = Par_CreditoID;

        -- ACTUALIZAR DATOS DEL MONTO TOTAL A LIQUIDAR
        UPDATE TMPREPORTENOTIFICA tmp  SET
			tmp.TotalAdeudoLiqui = FUNCIONCONFINIQCRE(tmp.CreditoID)
		WHERE tmp.CreditoID = Par_CreditoID;


       -- SE OBTIENE LA FECHA DONDE SE EMPEZO A ATRASAR
	   SET Var_FechaAtrasadaP	:=	(SELECT		MIN(FechaVencim) AS Var_FechaPago
										FROM 	AMORTICREDITO 	D
											WHERE	D.CreditoID	=	Par_CreditoID
												AND	FechaVencim	<=	Par_FechaSis
                                                AND Estatus IN(Est_Vencido,Est_Atrasado)
											GROUP BY D.CreditoID);
		-- ACTUALIZA FECHA EN TABLA
        UPDATE TMPREPORTENOTIFICA tmp  SET
			tmp.FechaAtrasadaPago = Var_FechaAtrasadaP
		WHERE tmp.CreditoID = Par_CreditoID;


		-- AVALES(CUANDO EL FORMATO DE NOTIFICACION ES PARA LOS AVALES DE CONSULTA SU DIRECCION)
        SET Var_TipoFormaNoti := (SELECT Tipo FROM FORMATONOTIFICACOB WHERE FormatoID = Par_FormatoID);

        IF(Var_TipoFormaNoti = Tipo_FormatoAval) THEN
        	UPDATE TMPREPORTENOTIFICA	T SET
				T.DireccionCompleta = Cadena_Vacia,
				T.DescripcionDirec	= Cadena_Vacia
			WHERE T.CreditoID = Par_CreditoID;

			-- SE ACTUALIZA INFORMACION SI ES SOLO AVAL
			UPDATE TMPREPORTENOTIFICA	T,
					AVALES				A	SET
				T.DireccionCompleta = A.DireccionCompleta
			WHERE Par_AvalID = A.AvalID
				AND T.CreditoID = Par_CreditoID;

			-- SE ACTUALIZA INFORMACION SI EL AVAL ES CLIENTE
			UPDATE	TMPREPORTENOTIFICA	T,
					DIRECCLIENTE		D	SET
				T.DireccionCompleta = D.DireccionCompleta,
				T.DescripcionDirec	= D.Descripcion
			WHERE Par_AvalClienteID = D.ClienteID
			AND D.Oficial = Cons_Si
            AND T.CreditoID = Par_CreditoID
            AND Par_AvalClienteID > Entero_Cero;
        END IF;




        SELECT 	CreditoID,		UsuarioID,			SucursalID,			CASE WHEN FechaCita=Fecha_Vacia THEN Cadena_Vacia ELSE FechaCita END AS FechaCita ,				HoraCita,
				ClienteID,      NombreCompleto, 	DireccionCompleta,	DescripcionDirec,		NombreSucursal,
                EstadoSucursal,	NumPagoVencidos,	Telefono,			NombreCompUsu,			NombreGerente,
                DireccionSucursal, FORMAT(TotalExigibleDia,2) AS TotalExigibleDia, FORMAT(TotalAdeudoLiqui,2) AS TotalAdeudoLiqui,	FechaAtrasadaPago
		FROM TMPREPORTENOTIFICA
			LIMIT 1;

END TerminaStore$$