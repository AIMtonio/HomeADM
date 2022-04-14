-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISRRETENIDOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISRRETENIDOREP`;DELIMITER $$

CREATE PROCEDURE `ISRRETENIDOREP`(
/* SP para reporte de ISR por socios*/
	Anio 		INT(4),				-- Año del reporte
    TipoReporte INT(4),				-- tipo de reporte a regresar
	/* parametros de auditoria*/
    Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN
-- Declaracion de constantes
	DECLARE RepPorteISR 		INT(4);
	DECLARE	Entero_Cero			DECIMAL(12,2);
    DECLARE	EstPag				CHAR(1);
    DECLARE	EstCan				CHAR(1);
    DECLARE EstActivoD			VARCHAR(10);
    DECLARE EstInacD			VARCHAR(10);
    DECLARE Const_SI			VARCHAR(2);
    DECLARE Const_NO			VARCHAR(2);
    DECLARE Const_S				CHAR(1);
    DECLARE Const_N				CHAR(1);
    DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE	Cadena_Espacio		VARCHAR(5);
    DECLARE EstActivo			CHAR(1);

-- Declaracion de variables
	SET	RepPorteISR		:= 1;			-- tipo de reporte
	SET Entero_Cero		:= 0;			-- entero valor cero
    SET EstPag			:= 'P';			-- estatus de inversion pagado
    SET EstCan			:= 'C';			-- estatus de inversion cancelada
    SET EstActivo		:= 'A';			-- estatus de socio activa
    SET EstActivoD		:= 'Activo';	-- estatus de socio
	SET EstInacD		:= 'Inactivo';	-- estatus de socio
    SET Const_SI		:= 'SI';		-- constante para mostar SI
    SET Const_NO		:= 'NO';		-- constante para mostar
    SET	Cadena_Vacia	:= '';			-- cadena vacia
    SET Cadena_Espacio	:= " ";			-- cadena espacio
    SET Const_S			:= 'S';			-- constante S
    SET Const_N			:= 'N';			-- constante N


	DROP TABLE IF EXISTS  TMPISRSOCIOS;

	IF TipoReporte=RepPorteISR THEN
	CREATE TEMPORARY TABLE TMPISRSOCIOS (
		ClienteID		INT(11),
		FechaInicial	DATE,
		FechaFinal		DATE,
		Intereses		DECIMAL(12,2),
		ISR				DECIMAL(12,2)
	);

	INSERT INTO TMPISRSOCIOS(
		ClienteID,	FechaInicial,	FechaFinal,		Intereses,		ISR)
	  SELECT
		HCUENTAS.ClienteID,	min(Fecha),		max(Fecha),		SUM(HCUENTAS.InteresesGen),		SUM(HCUENTAS.ISRReal)
		FROM  `HIS-CUENTASAHO` HCUENTAS
			WHERE	YEAR(Fecha)=Anio
				AND	ISRReal>Entero_Cero
					GROUP BY HCUENTAS.ClienteID;

	INSERT INTO TMPISRSOCIOS(
		ClienteID,	FechaInicial,	FechaFinal,		Intereses,		ISR)
	  SELECT
		Inv.ClienteID,		min(FechaVencimiento),		max(FechaVencimiento),		SUM(Inv.InteresRecibir),		SUM(Inv.ISRReal)
		FROM  INVERSIONES Inv
			WHERE	YEAR(FechaVencimiento)=Anio
				AND	ISRReal>Entero_Cero
				AND	(Estatus=EstPag OR Estatus=EstCan)
					GROUP BY  Inv.ClienteID;
	SELECT	C.ClienteID AS SocioID,
			MONTH(MIN(FechaInicial)) as PrimerMes,
			MONTH(MAX(FechaFinal)) as UltimoMes,
			C.SucursalOrigen AS Sucursal,
			CONCAT(C.PrimerNombre,Cadena_Espacio,IFNULL(C.SegundoNombre,Cadena_Vacia),Cadena_Espacio,IFNULL(C.TercerNombre,Cadena_Vacia),Cadena_Espacio,
            IFNULL(C.ApellidoPaterno,Cadena_Vacia),Cadena_Espacio,IFNULL(C.ApellidoMaterno,Cadena_Vacia)) AS NombreSocio,


			IFNULL(C.RFC,'') AS RFC,		IFNULL(C.CURP,'')AS CURP,		SUM(Intereses) as Intereses, 	SUM(ISR) as ISR,
            CASE WHEN C.Estatus=EstActivo  THEN
					EstActivoD
				ELSE
					EstInacD
				END AS Estatus,

			CASE WHEN C.EsMenorEdad=Const_S THEN
					Const_SI
				ELSE
					Const_NO
			END AS EsMenorEdad,
			CASE WHEN IFNULL(C.EsMenorEdad,Const_N)=Const_S  THEN
					CASE WHEN IFNULL(ClienteTutorID,Entero_Cero)=Entero_Cero  THEN
						NombreTutor
					ELSE
					 CONCAT(Cli.PrimerNombre,Cadena_Espacio,IFNULL(Cli.SegundoNombre,Cadena_Vacia),Cadena_Espacio,
                     IFNULL(Cli.TercerNombre,Cadena_Vacia),Cadena_Espacio,IFNULL(Cli.ApellidoPaterno,Cadena_Vacia),Cadena_Espacio,IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
					END

			   ELSE
					' '
			END AS NombreTutor,
			CASE WHEN IFNULL(C.EsMenorEdad,Const_N)=Const_S  THEN
					CASE WHEN IFNULL(ClienteTutorID,Entero_Cero)=Entero_Cero THEN
						''
					ELSE
						IFNULL(Cli.RFC,'')
					END
				ELSE
					' '
			END AS RFCTutor,
			CASE WHEN  IFNULL(C.EsMenorEdad,Const_N)=Const_S  THEN
					CASE WHEN IFNULL(ClienteTutorID,Entero_Cero)=Entero_Cero   THEN
						''
					ELSE
						IFNULL(Cli.CURP,Cadena_Vacia)
					END
				ELSE
					' '
			END	AS CURPTutor
		FROM	TMPISRSOCIOS ISR,CLIENTES C LEFT JOIN SOCIOMENOR
				ON SocioMenorID=C.ClienteID LEFT  JOIN  CLIENTES Cli
				ON ClienteTutorID=Cli.ClienteID
			WHERE
			C.ClienteID=ISR.ClienteID
			GROUP BY ISR.ClienteID,		C.ClienteID,	C.SucursalOrigen,			C.RFC, 		C.CURP,
					 C.Estatus,	C.EsMenorEdad, 	SOCIOMENOR.ClienteTutorID, 	SOCIOMENOR.NombreTutor;
	END IF;


	DROP TABLE IF EXISTS  TMPISRSOCIOS;
END TerminaStore$$