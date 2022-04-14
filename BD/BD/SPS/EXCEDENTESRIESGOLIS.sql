-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEDENTESRIESGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXCEDENTESRIESGOLIS`;DELIMITER $$

CREATE PROCEDURE `EXCEDENTESRIESGOLIS`(
# =====================================================================================
# ----- STORED PARA LISTAR LOS REGISTROS DE EXCEDENTES DE RIESGO ------------
# =====================================================================================

	Par_TipoLis				INT(11),		# Tipo de Lista
	Par_Fecha				DATE,	# Mes en la cual se listara los Excendentes

	-- Parametros de Auditoria
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion

)
TerminaStore: BEGIN

DECLARE	Registros			INT(11);
DECLARE Flag				INT(11);
DECLARE Var_Fecha			DATE;
DECLARE Var_FechaFin		DATE;
DECLARE Var_FechaInicio		DATE;

/* Declaracion de Constantes */
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE	Str_SI					CHAR(1);
DECLARE	Str_NO					CHAR(1);
DECLARE	Lista_Principal			INT(11);
DECLARE Var_Vigente				CHAR(1);
DECLARE Var_Vencido				CHAR(1);


/* Asignacion de Constantes */
SET	Cadena_Vacia				:= '';			-- Cadena Vacia
SET	Fecha_Vacia					:= '1900-01-01';-- Fecha Vacia
SET	Entero_Cero					:= 0;			-- Entero Cero
SET Decimal_Cero				:= 0.00;		-- Decimal Cero
SET	Str_SI						:= 'S';			-- Cadena de Si
SET	Str_NO						:= 'N';			-- Cadena de No
SET	Lista_Principal				:= 1;			-- Cadena de No
SET	Var_Vigente					:= 'V';			-- Cadena de No
SET	Var_Vencido					:= 'B';			-- Cadena de No



IF(Par_TipoLis = Lista_Principal) THEN
    SET Var_Fecha	:= DATE_FORMAT(Par_Fecha,'%Y-%m-01');

    SET Var_FechaInicio	:= date_sub(Var_Fecha, INTERVAL 1 MONTH);
	SET Var_FechaFin	:= LAST_DAY(Var_FechaInicio);

    SELECT COUNT(*) INTO Registros
		FROM EXCEDENTESGRUPOSRIESGO
			WHERE Fecha = Var_Fecha;
    IF (Registros > Entero_Cero) THEN
		SET Flag := 1;

	/*  LISTA DE EXCEDENTES DE RIEGO */
		SELECT GrupoID, RiesgoID, ClienteID, NombreIntegrante, TipoPersona,	RFC,
				CURP, SaldoIntegrante, SaldoGrupal, Flag
		   FROM EXCEDENTESGRUPOSRIESGO
			WHERE Fecha = Var_Fecha ORDER BY GrupoID, NombreIntegrante ;
	ELSE
		SET Flag := 0;

        /* SE CREA TABLA PARA SACAR LAS PERSONAS QUE PRESENTAN RIESGO COMUN*/
        /* TABLA GENERAL DE RIESGO COMUN*/

        DROP TABLE IF EXISTS TMPEXCEDENTERIESGO;
        CREATE TABLE TMPEXCEDENTERIESGO(
            GrupoID             INT(11),
            RiesgoID            VARCHAR (200),
            ClienteID           INT(11),
            CreditoID 			BIGINT(12),
            Fecha               DATE,
            NombreIntegrante    VARCHAR(200),
            TipoPersona         VARCHAR(20),
            RFC                 CHAR(13),
            CURP                CHAR(18),
            SaldoIntegrante     DOUBLE(14,2),
            SaldoGrupal         DOUBLE(14,2),
            KEY `idx_TMPEXCEDENTERIESGO_1` (`GrupoID`),
            KEY `idx_TMPEXCEDENTERIESGO_2` (`ClienteID`),
            KEY `idx_TMPEXCEDENTERIESGO_3` (`CreditoID`)
        );


        INSERT INTO TMPEXCEDENTERIESGO
        SELECT	GrupoID,			RiesgoID,		ClienteID,		CreditoID,		Fecha,
				NombreIntegrante,	TipoPersona,	RFC,			CURP,			Decimal_Cero,		Decimal_Cero
        FROM EXCEDENTERIESGOCOMUN
        WHERE Fecha >= Var_FechaInicio
			AND Fecha <= Var_FechaFin;

        -- Se insertan los clientes pivotes
        INSERT INTO TMPEXCEDENTERIESGO
        SELECT Ries.ConsecutivoID,		'',		Ries.ClienteID,		Cre.CreditoID,		Fecha_Vacia,
				Cli.NombreCompleto,
                CASE (Cli.TipoPersona)
						WHEN 'F' THEN 'FISICA'
                        WHEN 'M' THEN 'MORAL'
                        WHEN 'A' THEN 'FISICA'
					END AS TipoPersona,
					CASE (Cli.TipoPersona)
						WHEN 'F' THEN ''
						WHEN 'M' THEN Cli.RFCpm
                        WHEN 'A' THEN ''
					END AS RFC,
					CASE (Cli.TipoPersona)
						WHEN 'F' THEN Cli.CURP
                        WHEN 'M' THEN ''
                        WHEN 'A' THEN Cli.CURP
					END AS CURP,
                    Decimal_Cero,		Decimal_Cero
		FROM RIESGOCOMUNGRUPOS Ries INNER JOIN CLIENTES Cli ON Ries.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cli.ClienteID = Cre.ClienteID;


        -- Se actualiza el Saldo de los Creditos de cada Integrante
        UPDATE  TMPEXCEDENTERIESGO Tmp INNER JOIN SALDOSCREDITOS Sal ON Sal.CreditoID = Tmp.CreditoID SET
			Tmp.SaldoIntegrante = IFNULL((ROUND(Sal.SalCapVigente,2) 	+ ROUND(Sal.SalCapAtrasado,2)	+ ROUND(Sal.SalCapVencido,2)+
										ROUND(Sal.SalCapVenNoExi,2)		+ ROUND(Sal.SalIntOrdinario,2)	+ ROUND(Sal.SalIntAtrasado,2)+
										ROUND(Sal.SalIntVencido,2)		+ ROUND(Sal.SalIntProvision,2)	+ ROUND(Sal.SalIntNoConta,2)),Decimal_Cero)
		WHERE Sal.FechaCorte = Var_FechaFin;

		-- Se crea tabla para actualizar el Saldo Grupal
        DROP TABLE IF EXISTS TMPEXCEDENTERIESGOSALDOS;
        CREATE TABLE TMPEXCEDENTERIESGOSALDOS(
            GrupoID             INT(11),
            SaldoGrupal         DOUBLE(14,2),
            KEY `idx_TMPEXCEDENTERIESGOSALDOS_1` (`GrupoID`)
        );

        INSERT INTO TMPEXCEDENTERIESGOSALDOS
        SELECT GrupoID, SUM(SaldoIntegrante)
			FROM TMPEXCEDENTERIESGO
			GROUP BY GrupoID;


        UPDATE  TMPEXCEDENTERIESGO Tmp INNER JOIN TMPEXCEDENTERIESGOSALDOS Sal ON Tmp.GrupoID = Sal.GrupoID SET
			Tmp.SaldoGrupal = IFNULL(Sal.SaldoGrupal, Decimal_Cero)
		WHERE Tmp.GrupoID = Sal.GrupoID;


        INSERT INTO EXCEDENTESGRUPOSRIESGO
		SELECT MAX(GrupoID) AS GrupoID,	 		Cadena_Vacia AS RiesgoID, 		Var_Fecha,		ClienteID,		 MAX(NombreIntegrante) AS NombreIntegrante,
				MAX(TipoPersona) AS TipoPersona , 		MAX(RFC) AS RFC,		MAX(CURP) AS CURP,			SUM(SaldoIntegrante) AS SaldoIntegrante, 	MAX(SaldoGrupal) AS SaldoGrupal,
                Par_EmpresaID, 		Aud_Usuario,      Aud_FechaActual, 			Aud_DireccionIP, 			Aud_ProgramaID,
                Aud_Sucursal, Aud_NumTransaccion
			FROM TMPEXCEDENTERIESGO
            WHERE SaldoIntegrante > Entero_Cero
			GROUP BY GrupoID, ClienteID
			ORDER BY GrupoID, NombreIntegrante;

		SELECT GrupoID, RiesgoID, ClienteID, NombreIntegrante, TipoPersona,	RFC,
				CURP, SaldoIntegrante, SaldoGrupal
		   FROM EXCEDENTESGRUPOSRIESGO
			WHERE Fecha = Var_Fecha ORDER BY GrupoID, NombreIntegrante ;
    END IF;

END IF;


END TerminaStore$$