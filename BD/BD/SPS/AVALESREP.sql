-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESREP`;DELIMITER $$

CREATE PROCEDURE `AVALESREP`(
/* Store para desplegar la informacion de los avales en los contratos. */
	Par_Ident			INT(20),	-- dato que liga a la consulta de avales
	Par_Tipo			INT,		-- tipo de consulta segun el la fuente de datos, Solicitud, Credito, Cuenta, Inversion, Cetes
	Par_Seccion			INT,		-- tipo de seccion 0 para obtener la lista completa de avales
	Par_Limit			INT,		-- Limite de consulta de la lista
	/* Parametros de Auditoria*/
	Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN
	/* Variables */
	DECLARE Var_CreditoID	BIGINT(12);
	DECLARE Var_SolCredID	INT(20);
	DECLARE	APS_AvalID		INT(20);
	DECLARE	APS_ClienteID	INT(20);
	DECLARE	APS_ProspectoID	INT(20);
	DECLARE Cli_NombreComp	VARCHAR(250);
	DECLARE Cli_RepLegal	VARCHAR(250);
	DECLARE Var_RowCount	INT;
	DECLARE Fech_NomComplet	VARCHAR(250);
	DECLARE Fech_RepLegal	VARCHAR(250);

	DECLARE Tipo_Credito	INT;
	DECLARE Tipo_Solicitud	INT;
	DECLARE SecFirmaCartAyE INT;
	DECLARE SecAvalesOrdExp INT;
	DECLARE	EstAutorizado	CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Cadena_Default	CHAR(20);
	DECLARE	Entero_Cero		INT;
	DECLARE TipoPersonaMoral CHAR(1);
	DECLARE TipoPersonaFisi CHAR(1);
	DECLARE TipoPersonaFAEmp CHAR(1);
	DECLARE Constitutiva CHAR(1);
	DECLARE DePoderes	 CHAR(1);

	DECLARE CURSORAVALESGRAL CURSOR FOR
		SELECT	NumTransaccionID,	Identificador,	Consecutivo,		ClienteID,			ProspectoID,
				AvalID,				Nombres,		ApellidoPat,		ApellidoMat,		NombreCompleto,
				DatVivTipDom,		DirNumExt,		DirCalle,			DirColonia,			DirCP,
				DirLocalidad,		DirMunicipio,	DirEstado,			DirCompleta,		RFC,
				Sexo,				FechaNac,		Edad,				EdoNac,				PaisNac,
				Nacion,				Ocupacion,		Puesto,				GradoEstudio,		Profesion,
				ActEconom,			EdoCivil,		Telefono,			Correo,				CURP,
				TipoPersona,		RazonSocial,	RepLegal,			EscConsNumero,		EscPodNumero,
				EscConsCiud,		EscPodCiud,		EscConsLocalid,		EscPodLocalid,		EscConsFecha,
				EscPodFecha,		EscConsNomNotar,EscPodNomNotar,		EscConsNumNotar,	EscPodNumNotar,
				EscConsEdoNotar,	EscPodEdoNotar,	EscConsEdoReg,		EscPodEdoReg,		EscConsLocNotar,
				EscPodLocNotar,		EscPodNomApode,	EscPodNotaria,		EscConsNotaria,		SucursalOrigen,
				EmpresaID,			OcupacionID,	DomicilioTrabajo,	TelefonoTrabajo,	ExtTelTrabajo,
				Usuario,			FechaActual,	DireccionIP,		ProgramaID,			Sucursal,
				NumTransaccion
		FROM TMPAVALESREP WHERE NumTransaccionID	=	Aud_NumTransaccion  AND Identificador = Par_Ident;

	DECLARE CURSORAVALES CURSOR FOR
		SELECT NombreCompleto, RepLegal FROM TMPAVALESREP WHERE NumTransaccionID	=	Aud_NumTransaccion  AND Identificador = Par_Ident;

	SET		Tipo_Credito	:= 1;
	SET		Tipo_Solicitud	:= 2;
	SET		SecFirmaCartAyE	:= 1;
	SET		SecAvalesOrdExp := 2;
	SET		EstAutorizado	:= 'U';
	SET		Cadena_Vacia	:= '';
	SET		Cadena_Default	:= 'No Aplica';
	SET		Entero_Cero		:=	0;
	SET		TipoPersonaMoral:= 'M';
	SET		TipoPersonaFisi:= 'F';
	SET		TipoPersonaFAEmp:= 'A';
	SET		Constitutiva	:= 'C'; -- Tipo de acta constitutiva
	SET		DePoderes		:= 'P'; -- Tipo de acta de poderes

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

ManejoErrores: BEGIN

	IF IFNULL(Par_Ident, Entero_Cero) = Entero_Cero THEN
		LEAVE TerminaStore;
	END IF;
	IF Par_Tipo = Tipo_Credito OR Par_Tipo = Tipo_Solicitud THEN
		CASE Par_Tipo
			WHEN Tipo_Credito
				THEN
					SET Var_CreditoID := Par_Ident;
					SET	Var_SolCredID :=(
						SELECT
							cr.SolicitudCreditoID
						FROM
							CREDITOS cr
						WHERE
							cr.CreditoID = Var_CreditoID LIMIT 1);
			WHEN Tipo_Solicitud
				THEN
					SET Var_SolCredID := Par_Ident;
			ELSE
				LEAVE TerminaStore;
		END CASE;


		SET @rowcount := 0;
		INSERT INTO TMPAVALESREP (
			NumTransaccionID,	Identificador,		Consecutivo,		ClienteID,		ProspectoID,
			AvalID,				NombreCompleto,		RepLegal,			DirCalle,		DirNumExt,
			DirColonia,			DirMunicipio,		DirEstado,			DirCP,			RazonSocial,
			TipoPersona,		EscConsNumero,		EscPodNumero,		RFC,			SucursalOrigen,
			EdoCivil,			FechaNac,			DatVivTipDom,		Telefono,		Ocupacion,
			Nombres,			ApellidoPat,		ApellidoMat,		Puesto,			DirCompleta,
			OcupacionID,		DomicilioTrabajo,	TelefonoTrabajo,	ExtTelTrabajo,	TipoRelacion,
			TiempoDeConocido,   Aval_ant)
		SELECT
			Aud_NumTransaccion AS NumTransaccionID,
			Par_Ident,
			@rowcount := @rowcount +1 AS Consecutivo,
			IFNULL(cl.ClienteID,Entero_Cero),
			IFNULL(ps.ProspectoID,Entero_Cero),
			IFNULL(av.AvalID,Entero_Cero),
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					IF( cl.TipoPersona = TipoPersonaMoral, cl.RazonSocial, cl.NombreCompleto)
				WHEN aps.ProspectoID!= Entero_Cero THEN
					IF( ps.TipoPersona = TipoPersonaMoral, ps.RazonSocial, ps.NombreCompleto)
				ELSE
					IF( av.TipoPersona = TipoPersonaMoral, av.RazonSocial, av.NombreCompleto)
			END AS NombreCompleto,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					IF( cl.TipoPersona = TipoPersonaMoral,
						CONCAT(	cl.PrimerNombre, ' ',
								IFNULL(cl.SegundoNombre,''), ' ',
								IFNULL(cl.TercerNombre,''), ' ',
								cl.ApellidoPaterno, ' ',
								cl.ApellidoMaterno),
						Cadena_Default)
				WHEN aps.ProspectoID!= Entero_Cero THEN
					IF( ps.TipoPersona = TipoPersonaMoral,
						CONCAT(	ps.PrimerNombre, ' ',
								IFNULL(ps.SegundoNombre,''), ' ',
								IFNULL(ps.TercerNombre,''), ' ',
								ps.ApellidoPaterno, ' ',
								ps.ApellidoMaterno),
						Cadena_Default)
				ELSE
					IF( av.TipoPersona = TipoPersonaMoral,
						CONCAT(	av.PrimerNombre, ' ',
								IFNULL(av.SegundoNombre,''), ' ',
								IFNULL(av.TercerNombre,''), ' ',
								av.ApellidoPaterno, ' ',
								av.ApellidoMaterno),
						Cadena_Default)
			END AS RepLegal,
			CASE
				WHEN aps.AvalID		!= Entero_Cero THEN
					av.Calle
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					dc.Calle
				ELSE
					ps.Calle
			END AS Calle,
			CASE
				WHEN aps.AvalID!= Entero_Cero THEN
					av.NumExterior
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					dc.NumeroCasa
				ELSE
					ps.NumExterior
			END AS NumeroCasa,
			CASE
				WHEN aps.AvalID 	!= Entero_Cero THEN
					av.Colonia
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					dc.Colonia
				ELSE
					ps.Colonia
			END AS Colonia,
			mr.Nombre AS Municipio,
			er.Nombre AS Estado,
			CASE
				WHEN aps.AvalID		!= Entero_Cero THEN
					av.CP
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					dc.CP
				ELSE
					ps.CP
			END AS CP,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.RazonSocial
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.RazonSocial
				ELSE
					av.RazonSocial
			END AS RazonSocial,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.TipoPersona
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.TipoPersona
				ELSE
					av.TipoPersona
			END AS TipoPersona,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					(SELECT	EscP.EscrituraPublic
					FROM	ESCRITURAPUB EscP
					WHERE	EscP.ClienteID	=	cl.ClienteID
					AND		EscP.Esc_Tipo	=	Constitutiva
					LIMIT 1)
				ELSE
					Cadena_Default
			END AS EscConsNumero,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					(SELECT	EscP.EscrituraPublic
					FROM	ESCRITURAPUB EscP
					WHERE	EscP.ClienteID	=	cl.ClienteID
					AND		EscP.Esc_Tipo	=	DePoderes
					LIMIT 1)
				ELSE
					Cadena_Default
			END AS EscPodNumero,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.RFCOficial
				WHEN aps.ProspectoID!= Entero_Cero THEN
					IF( ps.TipoPersona = TipoPersonaMoral,
						ps.RFCpm,
						ps.RFC)
				ELSE
					IF( av.TipoPersona = TipoPersonaMoral,
						av.RFCpm,
						av.RFC)
			END AS RFC,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero OR aps.AvalID != Entero_Cero THEN
					(SELECT NombreSucurs FROM SUCURSALES WHERE SucursalID = cl.SucursalOrigen LIMIT 1)
				ELSE
					Cadena_Vacia
			END AS SucursalOrigen,
			CASE
				WHEN cl.ClienteID 	!= Entero_Cero THEN
					cl.EstadoCivil
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.EstadoCivil
				ELSE
					av.EstadoCivil
			END AS EdoCivil,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.FechaNacimiento
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.FechaNacimiento
				ELSE
					av.FechaNac
			END AS FechaNacimiento,
			CASE
				WHEN cl.ClienteID 	!= Entero_Cero THEN
					(	SELECT
							sv.TipoViviendaID
						FROM
							SOCIODEMOVIVIEN sv
						WHERE sv.ClienteID = cl.ClienteID LIMIT 1)
				ELSE
					(	SELECT
							tv.Descripcion
						FROM
							SOCIODEMOVIVIEN sv
							LEFT OUTER JOIN TIPOVIVIENDA tv ON tv.TipoViviendaID = sv.TipoViviendaID
						WHERE ProspectoID = aps.ProspectoID LIMIT 1)

			END AS DatVivTipDom,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.Telefono
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.Telefono
				ELSE
					av.Telefono
			END AS Telefono,
			CASE
				WHEN cl.ClienteID 	!= Entero_Cero THEN
					IF(cl.TipoPersona=TipoPersonaMoral,Cadena_Vacia, (SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = cl.OcupacionID LIMIT 1))
				WHEN aps.ProspectoID!= Entero_Cero THEN
					(SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = ps.OcupacionID LIMIT 1)
				ELSE
					(SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = av.OcupacionID LIMIT 1)
			END AS Ocupacion,
			CASE
				WHEN aps.ClienteID != Entero_Cero THEN
					TRIM(CONCAT(IFNULL(cl.PrimerNombre,' '),' ',IFNULL(cl.SegundoNombre,''),' ',IFNULL(cl.TercerNombre,'')))
				WHEN aps.ProspectoID != Entero_Cero THEN
					TRIM(CONCAT(IFNULL(ps.PrimerNombre,' '),' ',IFNULL(ps.SegundoNombre,''),' ',IFNULL(ps.TercerNombre,'')))
				ELSE
					TRIM(CONCAT(IFNULL(av.PrimerNombre,' '),' ',IFNULL(av.SegundoNombre,''),' ',IFNULL(av.TercerNombre,'')))
			END AS Nombres,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.ApellidoPaterno
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.ApellidoPaterno
				ELSE
					av.ApellidoPaterno
			END AS ApellidoPat,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.ApellidoMaterno
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.ApellidoMaterno
				ELSE
					av.ApellidoMaterno
			END AS ApellidoMat,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.Puesto
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.Puesto
				ELSE
					av.Puesto
			END AS Puesto,
			CASE
				WHEN aps.AvalID		!= Entero_Cero THEN
					av.DireccionCompleta
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					dc.DireccionCompleta
				ELSE
					Cadena_Vacia
			END AS DireccionCompleta,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.OcupacionID
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.OcupacionID
				ELSE
					av.OcupacionID
			END AS OcupacionID,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.DomicilioTrabajo
				WHEN aps.ProspectoID!= Entero_Cero THEN
					Cadena_Vacia
				ELSE
					av.DomicilioTrabajo
			END AS DomicilioTrabajo,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.TelTrabajo
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.TelTrabajo
				ELSE
					av.TelefonoTrabajo
			END AS TelefonoTrabajo,
			CASE
				WHEN aps.ClienteID 	!= Entero_Cero THEN
					cl.ExtTelefonoTrab
				WHEN aps.ProspectoID!= Entero_Cero THEN
					ps.ExtTelefonoTrab
				ELSE
					av.ExtTelTrabajo
			END AS ExtTelTrabajo,
			(SELECT Descripcion FROM TIPORELACIONES WHERE TipoRelacionID = aps.TipoRelacionID LIMIT 1) AS TipoRelacion,
			aps.TiempoDeConocido AS TiempoDeConocido,
   /*ALTER TABLE*/
			CASE WHEN
			(SELECT COUNT(*) FROM AVALESPORSOLICI WHERE ClienteID = aps.ClienteID AND ClienteID > 0  GROUP BY ClienteID) >1
			THEN 'SI'
            WHEN
            (SELECT COUNT(*) FROM AVALESPORSOLICI WHERE AvalID = aps.AvalID AND AvalID > 0 GROUP BY AvalID) >1
            THEN 'SI'
            ELSE 'NO'
            END AS Aval_old
        FROM
			AVALESPORSOLICI aps
			LEFT OUTER JOIN AVALES 			av ON av.AvalID 		= aps.AvalID
			LEFT OUTER JOIN CLIENTES		cl ON cl.ClienteID 		= aps.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE	dc ON dc.ClienteID 		= aps.ClienteID AND Oficial = 'S'
			LEFT OUTER JOIN PROSPECTOS		ps ON ps.ProspectoID 	= aps.ProspectoID
			LEFT OUTER JOIN ESTADOSREPUB 	er ON 	CASE
														WHEN aps.AvalID!= Entero_Cero THEN
															er.EstadoID = av.EstadoID
														WHEN aps.ClienteID 	!= Entero_Cero THEN
															er.EstadoID = dc.EstadoID
														ELSE
															er.EstadoID = ps.EstadoID
													END
			LEFT OUTER JOIN MUNICIPIOSREPUB mr ON 	CASE
														WHEN aps.AvalID	!= Entero_Cero THEN
															mr.EstadoID = av.EstadoID AND mr.MunicipioID = av.MunicipioID
														WHEN aps.ClienteID 	!= Entero_Cero THEN
															mr.EstadoID = dc.EstadoID AND mr.MunicipioID = dc.MunicipioID
														ELSE
															mr.EstadoID = ps.EstadoID AND mr.MunicipioID = ps.MunicipioID
													END
		WHERE
			aps.SolicitudCreditoID	= Var_SolCredID;

		CASE Par_Seccion
			WHEN Entero_Cero
				THEN
					SELECT * FROM TMPAVALESREP WHERE NumTransaccionID = Aud_NumTransaccion AND Identificador = Par_Ident;
			WHEN SecFirmaCartAyE
				THEN
					SET Var_RowCount := 1;
					SELECT
						IF(TipoPersona = TipoPersonaMoral, RazonSocial, NombreCompleto),
						IF(TipoPersona = TipoPersonaMoral,
							CONCAT(	cl.PrimerNombre, ' ',
								cl.SegundoNombre, ' ',
								cl.TercerNombre, ' ',
								cl.ApellidoPaterno, ' ',
								cl.ApellidoMaterno),
							Cadena_Default
						)
					INTO
						Cli_NombreComp, Cli_RepLegal
					FROM
						SOLICITUDCREDITO sc
						LEFT OUTER JOIN CLIENTES cl ON cl.ClienteID = sc.ClienteID
					WHERE
						sc.SolicitudCreditoID = Var_SolCredID;

					DROP TEMPORARY TABLE IF EXISTS TMPAVALESRPT;
					CREATE TEMPORARY TABLE TMPAVALESRPT(
						Fila		INT,
						NombresIzq 	VARCHAR(250),
						RepLegalIzq	VARCHAR(250),
						NombresDer 	VARCHAR(250),
						RepLegalDer	VARCHAR(250),
                        INDEX(Fila)
					);

					INSERT INTO TMPAVALESRPT VALUES(Var_RowCount, Cli_NombreComp, Cli_RepLegal, Cadena_Vacia, Cadena_Vacia);
					OPEN CURSORAVALES;
						BEGIN
							DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
							LOOP
								FETCH CURSORAVALES INTO
								Fech_NomComplet, Fech_RepLegal;

								IF Var_RowCount = 1 THEN
									UPDATE TMPAVALESRPT SET
										NombresDer = Fech_NomComplet,
										RepLegalDer= Fech_RepLegal
									WHERE
										Fila = Var_RowCount;
								ELSE
									INSERT INTO TMPAVALESRPT VALUES (Var_RowCount,Cadena_Vacia, Cadena_Vacia, Fech_NomComplet,Fech_RepLegal);
								END IF;
								SET Var_RowCount := Var_RowCount +1;
							END LOOP;
						END;
					CLOSE CURSORAVALES;
					IF Var_RowCount = 1 THEN
						UPDATE TMPAVALESRPT SET
							NombresDer = Cadena_Default,
							RepLegalDer= Cadena_Default
						WHERE
							Fila = Var_RowCount;
					END IF;
					SELECT * FROM TMPAVALESRPT;
					DELETE FROM TMPAVALESRPT;

			WHEN SecAvalesOrdExp
				THEN
				IF (Par_Limit <= 0 OR @rowcount < 0 OR @rowcount >= Par_Limit) THEN
					SELECT * FROM TMPAVALESREP WHERE NumTransaccionID = Aud_NumTransaccion AND Identificador = Par_Ident;
					LEAVE ManejoErrores;

				END IF;
				WHILE(@rowcount < Par_Limit) DO
					INSERT INTO TMPAVALESREP (
						NumTransaccionID,	Identificador,		Consecutivo,	ClienteID,			ProspectoID,
						AvalID,				NombreCompleto,		RepLegal,		DirCalle,			DirNumExt,
						DirColonia,			DirMunicipio,		DirEstado,		DirCP,				RazonSocial,
						TipoPersona,		EscConsNumero,		EscPodNumero,	RFC,				SucursalOrigen,
						EdoCivil,			FechaNac,			DatVivTipDom,	Telefono,			Ocupacion,
						Puesto,				DirCompleta,		OcupacionID,	DomicilioTrabajo,	TelefonoTrabajo,
						ExtTelTrabajo,		TipoRelacion,		TiempoDeConocido)
					SELECT
						Aud_NumTransaccion AS NumTransaccionID,
											Par_Ident,			@rowcount := @rowcount +1 AS Consecutivo,
																				Entero_Cero,	Entero_Cero,
						Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Entero_Cero;
				END WHILE;
					SELECT * FROM TMPAVALESREP WHERE NumTransaccionID = Aud_NumTransaccion AND Identificador = Par_Ident ;
			ELSE
				LEAVE ManejoErrores;
		END CASE;
	END IF;
END ManejoErrores;
	 DELETE FROM TMPAVALESREP	WHERE NumTransaccionID	=	Aud_NumTransaccion AND Identificador = Par_Ident;
END TerminaStore$$