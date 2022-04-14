DELIMITER ;
DROP PROCEDURE IF EXISTS CONTRATOAGRO010REP;

DELIMITER $$
CREATE PROCEDURE `CONTRATOAGRO010REP`(
-- SP QUE OBTIENE TODOS LOS DATOS UTILIZADOS PARA EL CONTRATO DE CRÉDITOS AGRO (EXCLUSIVO CONSOL).

	Par_CreditoID			BIGINT(12),				-- Numero de Credito
	Par_TipoConsulta		INT(11),				-- Indica el tipo de consulta

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CreditoID			BIGINT(12);		-- Numero de Credito
    DECLARE Var_ClienteID			INT(11);		-- Numero de Cliente
    DECLARE Var_SolicitudCredito	BIGINT(20);		-- Numero de la Solicitud de Credito
    DECLARE Var_NombreCliente		VARCHAR(200);	-- Nombre del Cliente
	DECLARE Var_MontoTotal			VARCHAR(100);	-- Monto Total del Credito
	DECLARE Var_PorcBonifNum		DECIMAL(14,4);	-- Porcentaje de Bonificacion
	DECLARE Var_PorcBonif			VARCHAR(100);	-- Porcentaje de Bonificacion Letra
	DECLARE Var_MontoBonif			VARCHAR(100);	-- Monto de la Bonificacion
	DECLARE Var_Plazo				VARCHAR(20);	-- Plazo del Credito
	DECLARE Var_TasaOrdinaria		VARCHAR(100);	-- Tasa Ordinaria
	DECLARE Var_TasaMoratoria		VARCHAR(100);	-- Tasa Moratoria
	DECLARE Var_CAT					VARCHAR(100);	-- CAT del Credito
	DECLARE Var_ComisionAdmon		VARCHAR(100);	-- Comision por Administracion
	DECLARE Var_MontoComAdm			VARCHAR(100);	-- Monto de la Comision por Administracion
	DECLARE Var_CoberturaSeguro		VARCHAR(100);	-- Cobertura del Seguro
	DECLARE Var_PrimaSeguro			VARCHAR(100); 	-- Prima del Seguro
    DECLARE Var_VigenciaSeguro		INT(11);		-- Vigencia del Seguro
    DECLARE Var_VigenciaSeguroLetra	VARCHAR(50);	-- Vigencia del Seguro en Letra
    DECLARE Var_VigSeguroLetraCap	VARCHAR(50);	-- Vigencai del Seguro Letra Capital
	DECLARE Var_DatosUEAU			VARCHAR(500);	-- Datos UEAU
	DECLARE Var_PorcGarLiquida		VARCHAR(100);	-- Porcentaje de Garantia Liquida
	DECLARE Var_MontoGarLiquida		VARCHAR(100);	-- Monto de la Garantia Liquida
	DECLARE Var_Reca				VARCHAR(250);	-- RECA
	DECLARE Var_DireccionSuc		VARCHAR(150);	-- Direccion de la Sucursal
	DECLARE Var_FechaIniCredito		VARCHAR(150);	-- Fecha de Inicio del Credito
	DECLARE Var_FechaNacRepLegal	VARCHAR(150);	-- Fecha de Nacimiento del Representante Legal
	DECLARE Var_DirecRepLegal		VARCHAR(150);	-- Direccion del Representante Legal
	DECLARE Var_IdentRepLegal		VARCHAR(150);	-- Identificacion del representante legal
	DECLARE Var_CargoRepLegal		VARCHAR(150);	-- Cargo del representante legal
	DECLARE Var_DirecCliente		VARCHAR(300);   -- Direccion del Cliente
    DECLARE Var_NomApoderadoLegal	VARCHAR(200);	-- Nombre del Representante Legal
    DECLARE Var_RelacionadoID		INT(11);		-- Indica el numero del Cliente si el Relacionado es un Cliente
    DECLARE Var_NomRepresentanteLeg	VARCHAR(200);	-- Indica el nombre del representante legal}
    DECLARE Var_DestinoCredito		VARCHAR(300);	-- Descripcion del Destino de Credito
    DECLARE Var_MontoCredito		DECIMAL(18,2);	-- Monto Original del Credito
    DECLARE Var_MontoLetra			VARCHAR(500);	-- Monto del Credito Solo en Letra
    DECLARE Var_PosicionCad			INT(11);		-- Posicion donde se encuentra el simbolo (
    DECLARE Var_EstatusCred			CHAR(1);		-- Estatus del Credito
    DECLARE Var_SucursalUsuario		INT(11);		-- Sucursal del Usuario de la Sucursal
	DECLARE Var_Frecuencia			VARCHAR(50);	-- Frecuencia
	DECLARE Var_TipoSociedad		VARCHAR(200);	-- Frecuencia

	-- Generales Agro
    DECLARE Var_NombreProd			VARCHAR(255);	-- Nombre comercial del producto de crédito.
    DECLARE Var_MontoDeuda			VARCHAR(255);	-- Capital + interés + iva
    DECLARE Var_MontoTotConcepInv	DECIMAL(14,4);	-- Monto total de los conceptos de inversión.
    DECLARE Var_RecursoPrestConInv	DECIMAL(14,4);	-- Monto total de los recursos del prestamo conceptos de inversión.
    DECLARE Var_RecursoSoliConInv	DECIMAL(14,4);	-- Monto total de los recursos del solictante conceptos de inversión.
    DECLARE Var_OtrosRecConInv		DECIMAL(14,4);	-- Monto total de otros recursos de conceptos de inversión.
    DECLARE Var_ProporcionGar		DECIMAL(14,4);	-- Proporción de la garantía.
    DECLARE Var_ProporcionLetra		VARCHAR(255);	-- Proporción de la garantía.
    DECLARE Var_SolicitudCreditoID	VARCHAR(255);	-- Número de solicitud de crédito.

    -- Avales
	DECLARE Var_NumRegistrosAval	INT(11);		-- Numero de Avales de un Credito
    DECLARE Var_Contador			INT(11);		-- Variable Auxiliar (Contador)
    DECLARE Var_APClienteID			INT(11);		-- Numero de Cliente(AVAL)
    DECLARE Var_APAvalID			BIGINT(11);		-- Numero de Aval(AVAL)
    DECLARE Var_APProspectoID		INT(11);		-- Numero de Prospecto(AVAL)
	DECLARE Var_AliasCliente		VARCHAR(200);	-- Alias del Cliente
    DECLARE Var_APAliasCliente		VARCHAR(200);	-- Alias del Cliente que es AVAL
    DECLARE Var_APAliasAval			VARCHAR(200);	-- Alias del Aval
    DECLARE Var_APAliasProspecto	VARCHAR(200);	-- Alias del Prospecto que es AVAL
    DECLARE Var_NombreAval			VARCHAR(200);	-- Nombre del Avales(Tabla Temporal)
    DECLARE Var_CadenaAvales		VARCHAR(500);	-- Variable que contiene la cadena de todos los avales de un credito

	-- Garantes
    DECLARE Var_NumRegistrosGarante	INT(11);		-- Numero de Avales de un Credito
    DECLARE Var_AGClienteID			INT(11);		-- Numero de Cliente(AVAL)
    DECLARE Var_AGAGaranteID		INT(11);		-- Numero de Aval(AVAL)
    DECLARE Var_AGProspectoID		BIGINT(20);		-- Numero de Prospecto(AVAL)
    DECLARE Var_AGAliasCliente		VARCHAR(200);	-- Alias del Cliente que es GARANTE
    DECLARE Var_AGAliasGarante		VARCHAR(200);	-- Alias del GARANTE
    DECLARE Var_AGAliasProspecto	VARCHAR(200);	-- Alias del Prospecto que es GARANTE
    DECLARE Var_NombreGarante		VARCHAR(200);	-- Nombre del Garante(Tabla Temporal)
    DECLARE Var_CadenaGarantes		VARCHAR(500);	-- Variable que contiene la cadena de todos los garantes de un credito

    -- Escritura Pública de la PF
    DECLARE Var_NumEscPub			VARCHAR(50);	-- Escritura Publica
    DECLARE Var_NumEscPubLetra		VARCHAR(500);	-- Numero de Escritura Publica en Letras
    DECLARE Var_FechaEscPub			DATE;			-- Fecha de Escritura Publica
    DECLARE Var_FechaEscPubLetra	VARCHAR(500);	-- Fecha de la Escritura Publica en Letra
    DECLARE Var_NumNotariaPub		INT(11);		-- Numero de Notaria Publica
    DECLARE Var_NumNotariaLetra		VARCHAR(500);	-- Numero de la Notaria en Letra
    DECLARE Var_NombreNotario		VARCHAR(200);	-- Nombre del Notario Publico
    DECLARE Var_MunicipioNotaria	INT(11);		-- Municipio Notaria Publica
    DECLARE Var_EstadoNotaria		INT(11);		-- Estado Notaria Publica
    DECLARE Var_FolioMercantil		VARCHAR(10);	-- Folio Mercantil
    DECLARE Var_NomEstadoEscPub		VARCHAR(100);	-- Nombre Estado Escritura Publica
    DECLARE Var_NomMunicipioEscPub	VARCHAR(150);	-- Nombre del Municipio de Escritura Publica

	-- Escritura Pública de la PM
	DECLARE Var_EscPublicPM			VARCHAR(200);
	DECLARE Var_FechaEscPM			VARCHAR(200);
	DECLARE Var_NotariaPM			VARCHAR(200);
	DECLARE Var_NombreNotarioPM		VARCHAR(200);
	DECLARE Var_MunicipioNotariaPM	VARCHAR(200);
	DECLARE Var_EstadoNotariaPM		VARCHAR(200);
	DECLARE Var_DireccionNotariaPM	VARCHAR(200);
	DECLARE Var_FolioMercantilPM	VARCHAR(200);

    -- Declaracion de Constantes
    DECLARE FrecSemanal				CHAR(1);
	DECLARE FrecDecenal             CHAR(1);
	DECLARE FrecCatorcenal          CHAR(1);
	DECLARE FrecQuincenal           CHAR(1);
	DECLARE FrecMensual             CHAR(1);
	DECLARE FrecPeriodica           CHAR(1);
	DECLARE FrecBimestral           CHAR(1);
	DECLARE FrecTrimestral          CHAR(1);
	DECLARE FrecTetramestral        CHAR(1);
	DECLARE FrecSemestral           CHAR(1);
	DECLARE FrecAnual               CHAR(1);
	DECLARE FrecUnico               CHAR(1);
	DECLARE FrecLibre               CHAR(1);

	DECLARE TxtSemanal              VARCHAR(20);
    DECLARE TxtDecenal				VARCHAR(20);
	DECLARE TxtCatorcenal           VARCHAR(20);
	DECLARE TxtQuincenal            VARCHAR(20);
	DECLARE TxtMensual              VARCHAR(20);
	DECLARE TxtPeriodica            VARCHAR(20);
    DECLARE TxtBimestral			VARCHAR(20);
	DECLARE TxtTrimestral			VARCHAR(20);
	DECLARE TxtTetramestral			VARCHAR(20);
	DECLARE TxtSemestral            VARCHAR(20);
	DECLARE TxtAnual                VARCHAR(20);
	DECLARE TxtLibres				VARCHAR(10);
	DECLARE TextUnico				VARCHAR(10);

	DECLARE Var_Generales			INT(11);		-- Constante: Consulta de datos generales del contrato.
	DECLARE Var_Cuotas				INT(11);		-- Constante: Consulta de datos del pagaré de crédito pactado con el cliente.
    DECLARE Con_Garantias			INT(11);		-- Constante: Consulta las Garantias de un Credito
    DECLARE Con_Avales				INT(11);		-- Constante: Consulta los Avales de un Credito
    DECLARE Con_Garantes			INT(11);		-- Constante: Consulta los Garantes de un Credito
    DECLARE Con_Int_Generales		INT(11);		-- COnstante: Consulta los Integrantes Relacionados a un Credito
    DECLARE Con_ListaGarantes		INT(11);		-- Constante: Lista de Garantes Relacionados al Credito
    DECLARE Con_ListaAvales			INT(11);		-- Constante: Lista de Avales Relacionados al Credito
	DECLARE Con_ListaUsuarios		INT(11);		-- Constante: Lista del Gerente y SubGerente
    DECLARE Con_GeneralesAgro		INT(11);		-- Constante: Datos Generales Agro.
	DECLARE Con_ListaPorcentGarFIRA	INT(11);		-- Constante: Porcentajes de garantías FIRA.
	DECLARE Con_ListaMinistracion	INT(11);		-- Constante: Lista el calendario de ministraciones.
	DECLARE Con_ListaGarantiasGaran	INT(11);		-- Constante: Lista las garantías y garantes.
	DECLARE Con_ListaConsejoAdmon	INT(11);		-- Constante: Lista de miembros del consejo de administración del cliente.
	DECLARE Con_Escrituras			INT(11);		-- Constante: Consulta de información de escrituras públicas.

    DECLARE Var_FormatoTasaConsol	CHAR(2);        -- Tasa. Formato Consol
	DECLARE Var_FormatoPesoConsol	CHAR(2);        -- Peso. Formato Consol
	DECLARE Var_MoraNVeces			CHAR(1);        -- Moratorios
	DECLARE Var_MoraTasa			CHAR(1);        -- Tasa Moratoria

	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Cadena_Vacia			CHAR(1);
    DECLARE Entero_Cero				INT(11);		-- Constante: Entero Cero
	DECLARE Var_SI					CHAR(1);
	DECLARE Var_Esta_Activo			CHAR(1);
    DECLARE Var_FiguraAval			CHAR(1);
	DECLARE Var_FiguraProspecto		CHAR(1);
	DECLARE Var_FiguraCliente		CHAR(1);
	DECLARE Var_FiguraGarante		CHAR(1);
	DECLARE Var_FirguraPersona		CHAR(1);

	-- Asignacion de Constantes
	SET Var_Generales			:= 1;
	SET Var_Cuotas				:= 2;
    SET Con_Garantias			:= 3;
    SET Con_Avales				:= 4;
    SET Con_Garantes			:= 5;
    SET Con_Int_Generales		:= 6;
    SET Con_ListaGarantes		:= 7;
    SET Con_ListaAvales			:= 8;
    SET Con_ListaUsuarios		:= 9;
    SET Con_GeneralesAgro		:= 10;
    SET Con_ListaPorcentGarFIRA	:= 11;
    SET Con_ListaMinistracion	:= 12;
    SET Con_ListaGarantiasGaran	:= 13;
	SET Con_ListaConsejoAdmon	:= 14;
	SET Con_Escrituras			:= 15;

	SET Var_FormatoTasaConsol	:= '%A';
	SET Var_FormatoPesoConsol	:= '$C';
	SET Var_MoraNVeces			:= 'N';
	SET Var_MoraTasa			:= 'T';
	SET Decimal_Cero			:= 0.00;
	SET Cadena_Vacia			:= '';
    SET Entero_Cero				:= 0;
	SET Var_SI					:= 'S';
	SET Var_Esta_Activo			:= 'A';
    SET Var_FiguraAval			:= 'A';
	SET Var_FiguraProspecto		:= 'P';
	SET Var_FiguraCliente		:= 'C';
	SET Var_FiguraGarante		:= 'G';
	SET Var_FirguraPersona		:= 'P';

	SET FrecSemanal				:= 'S';
    SET FrecDecenal				:= 'D';
    SET FrecCatorcenal			:= 'C';
    SET FrecQuincenal			:= 'Q';
    SET FrecMensual				:= 'M';
    SET FrecPeriodica			:= 'P';
    SET FrecBimestral			:= 'B';
    SET FrecTrimestral			:= 'T';
    SET FrecTetramestral		:= 'R';
	SET FrecSemestral			:= 'S';
    SET FrecAnual				:= 'A';
    SET FrecUnico				:= 'U';
    SET FrecLibre				:= 'L';
	SET TxtSemanal				:= 'semanales';
    SET TxtDecenal				:= 'decenales';
    SET TxtCatorcenal			:= 'catorcenales';
    SET TxtQuincenal			:= 'quincenales';
    SET TxtMensual				:= 'mensuales';
    SET TxtPeriodica			:= 'periodicos';
    SET TxtBimestral			:= 'bimestrales';
    SET TxtTrimestral			:= 'trimestrales';
    SET TxtTetramestral			:= 'tetramestrales';
	SET TxtSemestral			:= 'semestrales';
    SET TxtAnual				:= 'anuales';
    SET TxtLibres				:= 'libres';
    SET TextUnico				:= 'unicos';
	SET Var_CreditoID 			:= Par_CreditoID;

	-- Consulta de datos generales del contrato.
	IF(Par_TipoConsulta = Var_Generales) THEN
		SET Var_PorcBonifNum := 2.00;

		SELECT	C.ClienteID,	C.SolicitudCreditoID,	CONVPORCANT((IFNULL(MontoCredito, Decimal_Cero)), Var_FormatoPesoConsol, 'Peso', 'Nacional'),
				CONVPORCANT(IFNULL(Var_PorcBonifNum, 0.00), Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
                CONVPORCANT(IFNULL(SUM(IFNULL(MontoCredito, Decimal_Cero)) * Var_PorcBonifNum / 100, 0.00), Var_FormatoPesoConsol, 'Peso', 'Nacional'),
				IFNULL(CP.Descripcion, Cadena_Vacia),
                CONVPORCANT(IFNULL(TasaFija, Decimal_Cero), Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				CONVPORCANT(IF(C.TipCobComMorato = Var_MoraTasa,
							IFNULL(C.FactorMora, Decimal_Cero),
							IFNULL(C.FactorMora, Decimal_Cero) * IFNULL(TasaFija, Decimal_Cero)),
							Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				CONVPORCANT(IFNULL(ValorCAT, Decimal_Cero), Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.'),
				REPLACE(
				CONCAT(DAY(FechaInicio), ' (', FNLETRACAPITAL(FUNCIONSOLONUMLETRAS(DAY(FechaInicio))), ') días del mes de ',FNLETRACAPITAL(FUNCIONMESNOMBRE(FechaInicio)), ' del año ', YEAR(FechaInicio), ' (',
					SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)), 1, 1),
					LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)), 2, length(FUNCIONSOLONUMLETRAS(YEAR(FechaInicio)))-2))
					,')'), ' )', ')'),
				CONVPORCANT(MAX(IFNULL(PorcGarLiq, Decimal_Cero)), Var_FormatoTasaConsol, '2', ''),
				CONVPORCANT(IFNULL(SUM(AporteCliente), Decimal_Cero), Var_FormatoPesoConsol, '2', ')'),
                 IFNULL(P.RegistroRECA, Cadena_Vacia),
				CASE
					WHEN C.FrecuenciaCap = FrecSemanal        	THEN TxtSemanal
					WHEN C.FrecuenciaCap = FrecCatorcenal     	THEN TxtCatorcenal
					WHEN C.FrecuenciaCap = FrecQuincenal      	THEN TxtQuincenal
					WHEN C.FrecuenciaCap = FrecMensual        	THEN TxtMensual
					WHEN C.FrecuenciaCap = FrecPeriodica      	THEN TxtPeriodica
					WHEN C.FrecuenciaCap = FrecBimestral      	THEN TxtBimestral
					WHEN C.FrecuenciaCap = FrecTrimestral     	THEN TxtTrimestral
					WHEN C.FrecuenciaCap = FrecTetramestral   	THEN TxtTetramestral
					WHEN C.FrecuenciaCap = FrecSemestral      	THEN TxtSemestral
					WHEN C.FrecuenciaCap = FrecAnual			THEN TxtAnual
					WHEN C.FrecuenciaCap = FrecUnico            THEN TextUnico
					WHEN C.FrecuenciaCap = FrecDecenal			THEN TxtDecenal
				END,
                DC.Descripcion, C.MontoCredito
				INTO Var_ClienteID,	Var_SolicitudCredito,	Var_MontoTotal, Var_PorcBonif, Var_MontoBonif, Var_Plazo, Var_TasaOrdinaria,
                Var_TasaMoratoria, Var_CAT, Var_FechaIniCredito,Var_PorcGarLiquida, Var_MontoGarLiquida,
                Var_Reca,	Var_Frecuencia,	Var_DestinoCredito,	Var_MontoCredito
		FROM CREDITOS AS C
        INNER JOIN CREDITOSPLAZOS AS CP ON C.PlazoID = CP.PlazoID
        INNER JOIN PRODUCTOSCREDITO AS P ON C.ProductoCreditoID = P.ProducCreditoID
        INNER JOIN DESTINOSCREDITO DC ON C.DestinoCreID = DC.DestinoCreID
			WHERE C.CreditoID = Var_CreditoID;


		SELECT 	IFNULL(Cobertura, Decimal_Cero), 	IFNULL(Prima, Decimal_Cero), 	IFNULL(Vigencia , Decimal_Cero)
        INTO 	Var_CoberturaSeguro, 				Var_PrimaSeguro, 				Var_VigenciaSeguro
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Var_SolicitudCredito;

        SET Var_ComisionAdmon 	:= CONVPORCANT(0.00, Var_FormatoTasaConsol, '2', ' ANUAL MÁS I.V.A.');
		SET Var_MontoComAdm 	:= CONVPORCANT(0.00, Var_FormatoPesoConsol, 'Peso', 'Nacional');
		SET Var_CoberturaSeguro := CONVPORCANT(Var_CoberturaSeguro, Var_FormatoPesoConsol, 'Peso', 'Nacional');
        SET Var_PrimaSeguro 	:= CONVPORCANT(Var_PrimaSeguro, Var_FormatoPesoConsol, 'Peso', 'Nacional');

        SET Var_VigenciaSeguroLetra := (FUNCIONSOLONUMLETRAS(Var_VigenciaSeguro));
        SET Var_VigSeguroLetraCap := CONCAT(UPPER(LEFT(Var_VigenciaSeguroLetra,1)),SUBSTR(LOWER(Var_VigenciaSeguroLetra),2));


		SELECT CONCAT('Domicilio: ', IFNULL(DireccionUEAU, Cadena_Vacia), ' Tel: ',
				IFNULL(TelefonoUEAU, Cadena_Vacia), ', ', CONCAT(IFNULL(OtrasCiuUEAU, Cadena_Vacia),','),
                ' Fax. 37980237,'
				' www.consolnegocios.com', ' correo electrónico: ', IFNULL(CorreoUEAU, Cadena_Vacia))
				INTO Var_DatosUEAU
		FROM EDOCTAPARAMS;

		SET Var_DatosUEAU := IFNULL(Var_DatosUEAU, Cadena_Vacia);

		SELECT 'Tlajomulco de Zúñiga, Jalisco' INTO Var_DireccionSuc;


		SELECT IFNULL(D.DireccionCompleta, Cadena_Vacia) INTO Var_DirecCliente
	      FROM DIRECCLIENTE AS D
			WHERE D.ClienteID = Var_ClienteID
            AND D.Oficial = Var_SI;

		SET Var_NombreCliente := (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienteID);

		-- Se obtienen los datos del Representante Legal
		SET Var_RelacionadoID := (SELECT RelacionadoID FROM DIRECTIVOS WHERE ClienteID = 1 AND EsApoderado = 'S' LIMIT 1);
		IF(Var_RelacionadoID = Entero_Cero) THEN

            SELECT	D.NombreCompleto,		D.NumEscPub, 		D.FechaEscPub,		D.NotariaID, 		M.Nombre,
					Es.Nombre, 				D.FolioMercantil,	N.Titular,			FNFECHACOMPLETA(D.FechaNac,3),			D.Domicilio,
                    D.NumIdentific,			D.CargoID
			INTO 	Var_NomApoderadoLegal, 	Var_NumEscPub, 		Var_FechaEscPub, 	Var_NumNotariaPub,	Var_NomMunicipioEscPub,
					Var_NomEstadoEscPub, 	Var_FolioMercantil,	Var_NombreNotario,	Var_FechaNacRepLegal,	Var_DirecRepLegal,
                    Var_IdentRepLegal,		Var_CargoRepLegal
				FROM DIRECTIVOS D
                INNER JOIN NOTARIAS N 	ON D.NotariaID = N.NotariaID
										AND D.EstadoID = N.EstadoID
										AND D.MunicipioID = N.MunicipioID
				INNER JOIN ESTADOSREPUB  Es ON N.EstadoID = Es.EstadoID
				INNER JOIN MUNICIPIOSREPUB M ON N.MunicipioID = M.MunicipioID
                AND D.EstadoID = M.EstadoID
                AND EsApoderado = Var_SI
				WHERE D.ClienteID = 1;



        ELSE

             SELECT 	C.NombreCompleto,		E.EscrituraPublic,	E.FechaEsc,			E.Notaria,				M.Nombre,
						Es.Nombre, 				D.FolioMercantil,	N.Titular,			D.CargoID,				FNFECHACOMPLETA(C.FechaNacimiento,3)
				INTO	Var_NomApoderadoLegal, 	Var_NumEscPub, 		Var_FechaEscPub, 	Var_NumNotariaPub,		Var_NomMunicipioEscPub,
						Var_NomEstadoEscPub, 	Var_FolioMercantil,	Var_NombreNotario,	Var_CargoRepLegal,		Var_FechaNacRepLegal
					FROM DIRECTIVOS D
					INNER JOIN CLIENTES C ON D.RelacionadoID = C.ClienteID
					INNER JOIN ESCRITURAPUB E ON D.RelacionadoID  = E.ClienteID
					INNER JOIN NOTARIAS N ON E.Notaria = N.NotariaID
					AND E.EstadoIDEsc 	= N.EstadoID
					AND E.LocalidadEsc 	= N.MunicipioID
					INNER JOIN ESTADOSREPUB  Es ON N.EstadoID = Es.EstadoID
					INNER JOIN MUNICIPIOSREPUB M ON N.MunicipioID = M.MunicipioID
					WHERE D.RelacionadoID = Var_RelacionadoID
					AND D.ClienteID = 1
					ORDER BY E.FechaActual DESC
					LIMIT 1;

				SET Var_DirecRepLegal := (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID = Var_RelacionadoID AND Oficial = 'S');
				SET Var_IdentRepLegal := (SELECT NumIdentific FROM IDENTIFICLIENTE WHERE ClienteID = Var_RelacionadoID);
				SET Var_DirecRepLegal := IFNULL(Var_DirecRepLegal, Cadena_Vacia);
                SET Var_IdentRepLegal := IFNULL(Var_IdentRepLegal, Cadena_Vacia);

        END IF;

		-- Se actualiza el cargo del representante legal
		SET Var_CargoRepLegal := (SELECT Descripcion FROM CATCARGOS WHERE CargoID = '1');

        -- Se obtiene el nombre del representante legal
        SET Var_NomRepresentanteLeg := (SELECT NombreRepresentante FROM PARAMETROSSIS LIMIT 1);

        SET Var_AliasCliente := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE ClienteID = Var_ClienteID);

        SET Var_NomApoderadoLegal 	:= IFNULL(Var_NomApoderadoLegal, Cadena_Vacia);
        SET Var_NomRepresentanteLeg := IFNULL(Var_NomRepresentanteLeg, Cadena_Vacia);

        SET Var_NumEscPubLetra := CONCAT(Var_NumEscPub, '-', LOWER(FUNCIONSOLONUMLETRAS(Var_NumEscPub)));
		SET Var_FechaEscPubLetra :=  (SELECT CONCAT(RIGHT(Var_FechaEscPub,2),' ', LOWER(FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(DAY(Var_FechaEscPub)), 1, LENGTH(FUNCIONSOLONUMLETRAS(DAY(Var_FechaEscPub)))-1))),' de ',FUNCIONMESNOMBRE(Var_FechaEscPub),' del ',
		YEAR(Var_FechaEscPub),' ',LOWER((FUNCIONSOLONUMLETRAS(YEAR(Var_FechaEscPub))))));

		SET Var_NumNotariaLetra 	:= CONCAT(Var_NumNotariaPub, '-', LOWER(FUNCIONSOLONUMLETRAS(Var_NumNotariaPub)));
		SET Var_NomMunicipioEscPub 	:= FNLETRACAPITAL(Var_NomMunicipioEscPub);
        SET Var_NomEstadoEscPub		:= FNLETRACAPITAL(Var_NomEstadoEscPub);
        SET Var_NombreNotario		:= FNLETRACAPITAL(Var_NombreNotario);

		SET Var_PosicionCad 		:= (SELECT LOCATE('(', CONVPORCANT(Var_MontoCredito, '$C','','')));
		SET Var_MontoLetra			:= SUBSTR(CONVPORCANT(Var_MontoCredito, '$C','',''),Var_PosicionCad);

        SET Var_CreditoID 			:= IFNULL(Var_CreditoID, Decimal_Cero);
        SET Var_MontoTotal			:= IFNULL(Var_MontoTotal, Cadena_Vacia);
        SET Var_PorcBonif			:= IFNULL(Var_PorcBonif, Cadena_Vacia);
        SET Var_MontoBonif			:= IFNULL(Var_MontoBonif, Cadena_Vacia);
        SET Var_Plazo				:= IFNULL(Var_Plazo, Cadena_Vacia);
        SET Var_TasaOrdinaria		:= IFNULL(Var_TasaOrdinaria, Cadena_Vacia);
        SET Var_TasaMoratoria		:= IFNULL(Var_TasaMoratoria, Cadena_Vacia);
        SET Var_CAT					:= IFNULL(Var_CAT, Cadena_Vacia);
        SET Var_ComisionAdmon		:= IFNULL(Var_ComisionAdmon, Cadena_Vacia);
        SET Var_CoberturaSeguro		:= IFNULL(Var_CoberturaSeguro, Cadena_Vacia);
        SET Var_PrimaSeguro			:= IFNULL(Var_PrimaSeguro,	Cadena_Vacia);
        SET Var_DatosUEAU			:= IFNULL(Var_DatosUEAU, Cadena_Vacia);
        SET Var_PorcGarLiquida		:= IFNULL(Var_PorcGarLiquida, Cadena_Vacia);
        SET Var_MontoGarLiquida		:= IFNULL(Var_MontoGarLiquida,	Cadena_Vacia);
        SET Var_Reca				:= IFNULL(Var_Reca, Cadena_Vacia);
        SET Var_DireccionSuc		:= IFNULL(Var_DireccionSuc, Cadena_Vacia);
        SET Var_FechaNacRepLegal	:= IFNULL(Var_FechaNacRepLegal, Cadena_Vacia);
		SET Var_CargoRepLegal		:= IFNULL(Var_CargoRepLegal, Cadena_Vacia);
        SET Var_DirecRepLegal		:= IFNULL(Var_DirecRepLegal, Cadena_Vacia);
        SET Var_IdentRepLegal		:= IFNULL(Var_IdentRepLegal, Cadena_Vacia);
        SET Var_FechaIniCredito		:= IFNULL(Var_FechaIniCredito, Cadena_Vacia);
        SET Var_DirecCliente		:= IFNULL(Var_DirecCliente, Cadena_Vacia);
        SET Var_NombreCliente		:= IFNULL(Var_NombreCliente, Cadena_Vacia);
        SET Var_VigSeguroLetraCap	:= IFNULL(Var_VigSeguroLetraCap, Cadena_Vacia);
        SET Var_NomRepresentanteLeg	:= IFNULL(Var_NomRepresentanteLeg, Cadena_Vacia);
        SET Var_AliasCliente		:= IFNULL(Var_AliasCliente, Cadena_Vacia);
        SET Var_NomApoderadoLegal	:= IFNULL(Var_NomApoderadoLegal, Cadena_Vacia);
        SET Var_NumEscPubLetra		:= IFNULL(Var_NumEscPubLetra, Cadena_Vacia);
        SET Var_FechaEscPubLetra	:= IFNULL(Var_FechaEscPubLetra, Cadena_Vacia);
        SET Var_NumNotariaLetra		:= IFNULL(Var_NumNotariaLetra, Cadena_Vacia);
		SET Var_NomMunicipioEscPub	:= IFNULL(Var_NomMunicipioEscPub, Cadena_Vacia);
		SET Var_NomEstadoEscPub		:= IFNULL(Var_NomEstadoEscPub, Cadena_Vacia);
        SET Var_FolioMercantil		:= IFNULL(Var_FolioMercantil, Cadena_Vacia);
        SET Var_NombreNotario		:= IFNULL(Var_NombreNotario, Cadena_Vacia);
        SET Var_Frecuencia			:= IFNULL(Var_Frecuencia, Cadena_Vacia);
        SET Var_DestinoCredito		:= IFNULL(Var_DestinoCredito, Cadena_Vacia);
        SET Var_MontoLetra			:= IFNULL(Var_MontoLetra, Cadena_Vacia);


		SELECT	Var_CreditoID AS CreditoID,						Var_MontoTotal AS MontoTotal,				Var_PorcBonif AS PorcBonif,					Var_MontoBonif AS MontoBonif,					Var_Plazo AS Plazo,
				Var_TasaOrdinaria AS TasaOrdinaria,				Var_TasaMoratoria AS TasaMoratoria,			Var_CAT AS CAT,								Var_ComisionAdmon AS ComisionAdmon,				Var_MontoComAdm AS MontoComAdm,
				Var_CoberturaSeguro AS CoberturaSeguro,			Var_PrimaSeguro AS PrimaSeguro,				Var_DatosUEAU AS DatosUEAU,					Var_PorcGarLiquida AS PorcGarLiquida, 			Var_MontoGarLiquida AS MontoGarLiquida,
                Var_Reca AS Reca,								Var_DireccionSuc AS DireccionSuc, 			Var_FechaNacRepLegal AS FechaNacRepLegal, 	Var_DirecRepLegal AS DirecRepLegal,				Var_IdentRepLegal AS IdentRepLegal,
                Var_FechaIniCredito AS FechaIniCredito,			Var_DirecCliente AS DireccionCliente,		Var_NombreCliente AS NombreCliente,			Var_VigSeguroLetraCap AS VigenciaSeguroLetra,	Var_NomRepresentanteLeg AS NomRepresentanteLeg,
                Var_AliasCliente AS AliasCliente,				Var_NomApoderadoLegal AS NomApoderadoLegal, Var_NumEscPubLetra AS NumEscPub, 			Var_FechaEscPubLetra AS FechaEscPub,         	Var_NumNotariaLetra	 AS NumNotariaPub,
                Var_NomMunicipioEscPub AS NomMunicipioEscPub,	Var_NomEstadoEscPub AS NomEstadoEscPub, 	Var_FolioMercantil AS FolioMercantil, 		Var_NombreNotario AS NombreNotario,				Var_Frecuencia AS Frecuencia,
                UPPER(Var_DestinoCredito) AS DestinoCredito,	Var_MontoLetra AS MontoLetra,				Var_CargoRepLegal AS CargoRepLegal;

	END IF;

	-- Consulta de datos del pagaré de crédito pactado con el cliente.
	IF(Par_TipoConsulta = Var_Cuotas) THEN
		SET Var_EstatusCred := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Var_CreditoID);

        IF(Var_EstatusCred = 'I' OR Var_EstatusCred = 'A') THEN
			SELECT A.AmortizacionID, FNFECHATEXTO(FechaVencim)	 AS FechaPago,
				   CONVPORCANT((A.Capital + A.Interes + A.IVAInteres), '$C', 'PESOS', 'NACIONAL') AS MontoCuota
			  FROM AMORTICREDITO AS A
				   INNER JOIN CREDITOS AS C
							  ON C.CreditoID = A.CreditoID
				WHERE C.CreditoID = Var_CreditoID;
		ELSE
			SELECT P.AmortizacionID, FNFECHATEXTO(FechaVencim)	 AS FechaPago,
				   CONVPORCANT((P.Capital + P.Interes + P.IVAInteres), '$C', 'PESOS', 'NACIONAL') AS MontoCuota
			  FROM PAGARECREDITO AS P
				   INNER JOIN CREDITOS AS C
							  ON C.CreditoID = P.CreditoID
				WHERE C.CreditoID = Var_CreditoID;
        END IF;
	END IF;

	-- Lista las Garantias asignadas al credito
	IF(Par_TipoConsulta = Con_Garantias) THEN
		SELECT  CASE WHEN TipoGarantiaID = 2 THEN 'Garantia Mobiliaria'
					ELSE 'Garantia Hipotecaria' END AS TipoGarantia, Gar.Observaciones
		  FROM      CREDITOS Cre
			INNER JOIN  ASIGNAGARANTIAS Asi   ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
			INNER JOIN  GARANTIAS Gar     ON Gar.GarantiaID = Asi.GarantiaID
		  WHERE Cre.CreditoID =Var_CreditoID;
	END IF;

    -- Lista los Avales asignados a un credito
    IF(Par_TipoConsulta = Con_Avales) THEN

		SET @Cont := Entero_Cero;

        -- Se crea y se llena tabla con los avales que tiene el credito
		DROP TABLE IF EXISTS TMPDATOSAVALESCONSOL;
		CREATE TEMPORARY TABLE TMPDATOSAVALESCONSOL

		SELECT Cre.CreditoID,
			AP.ClienteID, AP.AvalID, AP.ProspectoID,
			CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
					C.NombreCompleto
				ELSE
					CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
							A.NombreCompleto
						ELSE
							P.NombreCompleto
					END
			END AS  AvalNombreCompleto

			FROM  AVALESPORSOLICI AP
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
				LEFT OUTER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
				LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = AP.ClienteID
				LEFT OUTER JOIN AVALES        A ON  A.AvalID        = AP.AvalID
				LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = AP.ProspectoID
			  WHERE Cre.CreditoID = Var_CreditoID;



     -- FILTRA SI EL AVAL SOLO TIENE UNA
		DROP TABLE IF EXISTS TMPDATOSAVALESCONSOLv1;
		CREATE TEMPORARY TABLE TMPDATOSAVALESCONSOLv1
			SELECT distinct  Tm.CreditoID,Tm.ClienteID,Tm.AvalID,Tm.ProspectoID,Tm.AvalNombreCompleto
			from TMPDATOSAVALESCONSOL Tm
			     where Tm.AvalID is not null;


        -- Se crea y se llena tabla con los avales que tiene el credito
		DROP TABLE IF EXISTS TMPDATOSAVALESCONSOL;
		CREATE TEMPORARY TABLE TMPDATOSAVALESCONSOL

		SELECT (@Cont:=@Cont+1) AS Consecutivo, v1.CreditoID,
			v1.ClienteID, v1.AvalID, v1.ProspectoID,
		     v1.AvalNombreCompleto
            from TMPDATOSAVALESCONSOLv1 v1 ;



		-- Se obtiene el numero de registros de la tabla
		SET Var_NumRegistrosAval := (SELECT COUNT(*) FROM TMPDATOSAVALESCONSOL WHERE CreditoID = Var_CreditoID);

		SET Var_Contador := 1;
        SET Var_CadenaAvales := '';
		# INICIA CICLO PARA ARMAR LA CADENA DE AVALES
		CICLO: WHILE(Var_Contador <= Var_NumRegistrosAval) DO

            SET Var_APAliasCliente 		:= Cadena_Vacia;
			SET Var_APAliasAval 		:= Cadena_Vacia;
			SET Var_APAliasProspecto	:= Cadena_Vacia;
            SET Var_NombreAval			:= Cadena_Vacia;

            -- Se obtienen los datos del primer registro
            SELECT 	Tmp.ClienteID,		Tmp.AvalID,		Tmp.ProspectoID,	Tmp.AvalNombreCompleto
            INTO 	Var_APClienteID, 	Var_APAvalID,	Var_APProspectoID,	Var_NombreAval
            FROM TMPDATOSAVALESCONSOL Tmp
            WHERE Tmp.CreditoID = Par_CreditoID AND Tmp.Consecutivo = Var_Contador;

			-- Si el numero del cliente que es aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
			IF(Var_APClienteID > Entero_Cero) THEN
				SET Var_APAliasCliente := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE ClienteID = Var_APClienteID);
            END IF;

            -- Si el numero de aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
            IF(Var_APAvalID > Entero_Cero) THEN
				SET Var_APAliasAval := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE AvalID = Var_APAvalID);
            END IF;

            -- Si el numero de prospecot que es aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
             IF(Var_APProspectoID > Entero_Cero) THEN
				SET Var_APAliasProspecto := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE ProspectoID = Var_APProspectoID);
            END IF;



			SET Var_APAliasCliente 		:= IFNULL(Var_APAliasCliente, Cadena_Vacia);
			SET Var_APAliasAval 		:= IFNULL(Var_APAliasAval, Cadena_Vacia);
			SET Var_APAliasProspecto	:= IFNULL(Var_APAliasProspecto, Cadena_Vacia);

			IF(Var_Contador < Var_NumRegistrosAval OR (Var_NumRegistrosAval = 1)) THEN
                IF(Var_APAliasCliente <> Cadena_Vacia ) THEN

					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasCliente, ', ');
            ELSE
					IF(Var_APClienteID > Entero_Cero) THEN
						SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ', ');
					END IF;
                END IF;

                IF(Var_APAliasAval <> Cadena_Vacia) THEN
					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasAval , ', ');
				ELSE
					IF(Var_APAvalID > Entero_Cero) THEN
						SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ', ');
					END IF;
               END IF;

                 IF(Var_APAliasProspecto <> Cadena_Vacia) THEN
					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasProspecto, ', ');
                ELSE
					IF(Var_APProspectoID > Entero_Cero) THEN
						SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, Var_NombreAval, ', ');
					END IF;
                END IF;

			ELSE
				SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, 'Y ',  Var_NombreAval);

				IF(Var_APAliasCliente <> Cadena_Vacia) THEN
					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasCliente);
                END IF;

                IF(Var_APAliasAval <> Cadena_Vacia) THEN
					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasAval);
                END IF;

                 IF(Var_APAliasProspecto <> Cadena_Vacia) THEN
					SET Var_CadenaAvales := CONCAT(Var_CadenaAvales, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_APAliasProspecto);
                END IF;

			END IF;
			SET Var_Contador := Var_Contador + 1;
		END WHILE CICLO;

		SELECT Var_CadenaAvales;

    END IF;


    -- Lista los Garantes asignados a un credito
    IF(Par_TipoConsulta = Con_Garantes) THEN

		SET @Cont := Entero_Cero;

        -- Se crea y se llena tabla con los avales que tiene el credito

		DROP TABLE IF EXISTS TMPDATOSGARANTESCONSOL;
		CREATE TEMPORARY TABLE TMPDATOSGARANTESCONSOL
		SELECT Cre.CreditoID,
			Gar.ClienteID, Gar.GaranteID, Gar.ProspectoID,
			CASE  WHEN  IFNULL(Gar.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
					C.NombreCompleto
				ELSE
					CASE  WHEN  IFNULL(Gar.GaranteID,Entero_Cero) <> Entero_Cero  THEN
							GT.NombreCompleto
						ELSE
							P.NombreCompleto
					END
			END AS  GaranteNombreCompleto

			FROM  ASIGNAGARANTIAS AG
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AG.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AG.SolicitudCreditoID
                INNER JOIN GARANTIAS  Gar ON AG.GarantiaID = Gar.GarantiaID
				INNER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
				LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = Gar.ClienteID
				LEFT OUTER JOIN GARANTES  GT ON  GT.GaranteID        = Gar.GaranteID
				LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = Gar.ProspectoID
			  WHERE Cre.CreditoID = Var_CreditoID;



		DROP TABLE IF EXISTS TMPDATOSGARANTESCONSOLv2;
				CREATE TEMPORARY TABLE TMPDATOSGARANTESCONSOLv2
					SELECT distinct  Tm.CreditoID,Tm.ClienteID,Tm.GaranteID,Tm.ProspectoID,
						  Tm.GaranteNombreCompleto
					from TMPDATOSGARANTESCONSOL as Tm;


		DROP TABLE IF EXISTS TMPDATOSGARANTESCONSOL;
		  CREATE TEMPORARY TABLE TMPDATOSGARANTESCONSOL
			SELECT (@Cont:=@Cont+1) AS Consecutivo, v1.CreditoID,
				v1.ClienteID, v1.GaranteID, v1.ProspectoID,
				v1.GaranteNombreCompleto
				FROM TMPDATOSGARANTESCONSOLv2  v1;



		-- Se obtiene el numero de registros de la tabla
		SET Var_NumRegistrosGarante := (SELECT COUNT(*) FROM TMPDATOSGARANTESCONSOL WHERE CreditoID = Var_CreditoID);

		SET Var_Contador := 1;
        SET Var_CadenaGarantes := '';
		# INICIA CICLO PARA ARMAR LA CADENA DE AVALES
		CICLO: WHILE(Var_Contador <= Var_NumRegistrosGarante) DO

            SET Var_AGAliasCliente 		:= Cadena_Vacia;
			SET Var_AGAliasGarante 		:= Cadena_Vacia;
			SET Var_AGAliasProspecto	:= Cadena_Vacia;
            SET Var_NombreGarante		:= Cadena_Vacia;

            -- Se obtienen los datos del primer registro
            SELECT 	Tmp.ClienteID,		Tmp.GaranteID,		Tmp.ProspectoID,	Tmp.GaranteNombreCompleto
            INTO 	Var_AGClienteID, 	Var_AGAGaranteID,	Var_AGProspectoID,	Var_NombreGarante
            FROM TMPDATOSGARANTESCONSOL Tmp
            WHERE Tmp.CreditoID = Par_CreditoID AND Tmp.Consecutivo = Var_Contador;


			-- Si el numero del cliente que es aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
			IF(Var_AGClienteID > Entero_Cero) THEN
				SET Var_AGAliasCliente := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE ClienteID = Var_AGClienteID);
            END IF;

            -- Si el numero de aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
            IF(Var_AGAGaranteID > Entero_Cero) THEN
				SET Var_AGAliasGarante := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE GaranteID = Var_AGAGaranteID);
            END IF;

            -- Si el numero de prospecot que es aval es mayor a cero, si busca si tiene registrado una inconsistencia con su nombre
             IF(Var_AGProspectoID > Entero_Cero) THEN
				SET Var_AGAliasProspecto := (SELECT NombreCompleto FROM INCONSISTENCIAS WHERE ProspectoID = Var_AGProspectoID);
            END IF;



			SET Var_AGAliasCliente 		:= IFNULL(Var_AGAliasCliente, Cadena_Vacia);
			SET Var_AGAliasGarante 		:= IFNULL(Var_AGAliasGarante, Cadena_Vacia);
			SET Var_AGAliasProspecto	:= IFNULL(Var_AGAliasProspecto, Cadena_Vacia);

			IF(Var_Contador < Var_NumRegistrosGarante OR (Var_NumRegistrosGarante = 1)) THEN
                IF(Var_AGAliasCliente <> Cadena_Vacia ) THEN

					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasCliente, ', ');
            ELSE
					IF(Var_AGClienteID > Entero_Cero) THEN
						SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ', ');
					END IF;
                END IF;

                IF(Var_AGAliasGarante <> Cadena_Vacia) THEN
					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasGarante , ', ');
				ELSE
					IF(Var_AGAGaranteID > Entero_Cero) THEN
						SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ', ');
					END IF;
               END IF;

                 IF(Var_AGAliasProspecto <> Cadena_Vacia) THEN
					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasProspecto, ', ');
                ELSE
					IF(Var_AGProspectoID > Entero_Cero) THEN
						SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, Var_NombreGarante, ', ');
					END IF;
                END IF;

			ELSE
				SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, 'Y ',  Var_NombreGarante);

				IF(Var_AGAliasCliente <> Cadena_Vacia) THEN
					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasCliente);
                END IF;

                IF(Var_AGAliasGarante <> Cadena_Vacia) THEN
					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasGarante);
                END IF;

                 IF(Var_AGAliasProspecto <> Cadena_Vacia) THEN
					SET Var_CadenaGarantes := CONCAT(Var_CadenaGarantes, ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) ', Var_AGAliasProspecto);
                END IF;

			END IF;
			SET Var_Contador := Var_Contador + 1;
		END WHILE CICLO;

		SELECT Var_CadenaGarantes;

    END IF;


    -- Lista los Integrantes relacionados al credito
    IF(Par_TipoConsulta = Con_Int_Generales) THEN
		 SET @Cont := 0;
		DROP TABLE IF EXISTS TMPDATOSGENERALESCONSOL;
		CREATE TEMPORARY TABLE TMPDATOSGENERALESCONSOL(
        Consecutivo 	INT(11),
        CreditoID 		BIGINT(12),
        ClienteID		INT(11),
        GaranteID		INT(11),
        ProspectoID		BIGINT(20),
        AvalID			BIGINT(20),
        UsuarioID		INT(11),
        EmpleadoID      BIGINT(20),
        Nombre			VARCHAR(200),
        RFC				CHAR(13),
        Domicilio 		VARCHAR(500),
        Identificacion	VARCHAR(30),
		KEY `INDEX_TMPDATOSGENERALESCONSOL_1` (`CreditoID`,`ClienteID`),
		KEY `INDEX_TMPDATOSGENERALESCONSOL_2` (`CreditoID`,`GaranteID`),
		KEY `INDEX_TMPDATOSGENERALESCONSOL_3` (`CreditoID`,`ProspectoID`),
		KEY `INDEX_TMPDATOSGENERALESCONSOL_4` (`CreditoID`,`AvalID`),
		KEY `INDEX_TMPDATOSGENERALESCONSOL_5` (`CreditoID`,`EmpleadoID`));


        -- Se insertan los datos del Cliente
        INSERT INTO TMPDATOSGENERALESCONSOL
		SELECT (@Cont:=@Cont+1) AS Consecutivo, Cre.CreditoID,
			C.ClienteID, 0, 0, 0 AS AvalID, 0,0,'' AS Nombre, '' AS RFC, '' AS Domicilio , '' AS Identificacion

			FROM  CLIENTES C
				INNER JOIN CREDITOS Cre ON C.ClienteID = Cre.ClienteID
			  WHERE Cre.CreditoID = Var_CreditoID;

        -- Se insertan los Garantes
		INSERT INTO TMPDATOSGENERALESCONSOL
		SELECT (@Cont:=@Cont+1) AS Consecutivo, Cre.CreditoID,
			Gar.ClienteID, Gar.GaranteID, Gar.ProspectoID, 0 AS AvalID, 0,0,'' AS Nombre, '' AS RFC, '' AS Domicilio , '' AS Identificacion


			FROM  ASIGNAGARANTIAS AG
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AG.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AG.SolicitudCreditoID
                INNER JOIN GARANTIAS  Gar ON AG.GarantiaID = Gar.GarantiaID
			  WHERE Cre.CreditoID = Var_CreditoID;


      -- Se insertan los Avales
      INSERT INTO TMPDATOSGENERALESCONSOL
      SELECT (@Cont:=@Cont+1) AS Consecutivo, Cre.CreditoID,
			AP.ClienteID, 0 AS GaranteID,  AP.ProspectoID,  AP.AvalID, 0,0,'' AS Nombre, '' AS RFC, '' AS Domicilio , '' AS Identificacion

			FROM  AVALESPORSOLICI AP
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
			  WHERE Cre.CreditoID = Var_CreditoID;

		-- Se insertan el USUARIO que es GERENTE de la SUCURSAL
        SET Var_SucursalUsuario := (SELECT SucursalID FROM CREDITOS U WHERE CreditoID = Var_CreditoID);

        INSERT INTO TMPDATOSGENERALESCONSOL
        SELECT  (@Cont:=@Cont+1) AS Consecutivo, Var_CreditoID,0,0,0,0,U.UsuarioID,U.EmpleadoID,
				U.NombreCompleto,	IFNULL(U.RFC, ''),	IFNULL(U.DireccionCompleta,''),	IFNULL(U.FolioIdentificacion,'')
			FROM USUARIOS U
			INNER JOIN SUCURSALES S
			ON U.UsuarioID = S.NombreGerente
			WHERE S.SucursalID = Var_SucursalUsuario ;

        -- Se insertan el USUARIO que es SUBGERENTE de la SUCURSAL
		INSERT INTO TMPDATOSGENERALESCONSOL
        SELECT  (@Cont:=@Cont+1) AS Consecutivo, Var_CreditoID,0,0,0,0,U.UsuarioID,U.EmpleadoID,
				U.NombreCompleto,	IFNULL(U.RFC,''),	IFNULL(U.DireccionCompleta,''),	IFNULL(U.FolioIdentificacion,'')
			FROM USUARIOS U
			INNER JOIN SUCURSALES S
			ON U.UsuarioID = S.SubGerente
			WHERE S.SucursalID = Var_SucursalUsuario ;

	    UPDATE 	TMPDATOSGENERALESCONSOL AS TmUsu INNER JOIN EMPLEADOS as Em 
	    ON TmUsu.EmpleadoID=Em.EmpleadoID
	    SET TmUsu.Nombre=Em.NombreCompleto
	    where TmUsu.EmpleadoID is not null and TmUsu.CreditoID=Var_CreditoID;

        UPDATE TMPDATOSGENERALESCONSOL T
        INNER JOIN CLIENTES C ON T.ClienteID = C.ClienteID
        LEFT JOIN DIRECCLIENTE D ON T.ClienteID = D.ClienteID
        AND D.Oficial = Var_SI
        LEFT JOIN IDENTIFICLIENTE I ON T.ClienteID = I.ClienteID
        SET T.Nombre = C.NombreCompleto,
			T.RFC = IFNULL(C.RFCOficial,Cadena_Vacia),
			T.Domicilio = IFNULL(D.DireccionCompleta, Cadena_Vacia),
            T.Identificacion = IFNULL(I.NumIdentific, Cadena_Vacia)
		WHERE T.CreditoID = Var_CreditoID;

		UPDATE TMPDATOSGENERALESCONSOL T
        INNER JOIN GARANTES G ON T.GaranteID = G.GaranteID
        SET  T.Nombre = G.NombreCompleto,
			T.RFC = 	IFNULL(G.RFCOficial, Cadena_Vacia),
			T.Domicilio = IFNULL(G.DireccionCompleta, Cadena_Vacia),
            T.Identificacion = IFNULL(G.NumIdentific, Cadena_Vacia)
            WHERE T.CreditoID = Var_CreditoID;

		UPDATE TMPDATOSGENERALESCONSOL T
        INNER JOIN AVALES A ON T.AvalID = A.AvalID
        SET  T.Nombre = IFNULL(A.NombreCompleto, Cadena_Vacia),
			T.RFC = IFNULL(CASE WHEN A.TipoPersona = 'M' THEN A.RFCpm
					ELSE A.RFC END, Cadena_Vacia),
			T.Domicilio = IFNULL(A.DireccionCompleta, Cadena_Vacia),
            T.Identificacion = IFNULL(A.NumIdentific, Cadena_Vacia)
		WHERE T.CreditoID = Var_CreditoID;

		UPDATE TMPDATOSGENERALESCONSOL T
		INNER JOIN PROSPECTOS P ON T.ProspectoID = P.ProspectoID
		SET  T.Nombre = P.NombreCompleto,
			T.RFC = 	IFNULL(P.RFC, Cadena_Vacia)
            AND T.CreditoID = Var_CreditoID;

		DROP TABLE IF EXISTS TMPDATOSGENERALESCONSOLFi;
			CREATE TEMPORARY TABLE TMPDATOSGENERALESCONSOLFi(
		   Consecutivo 	INT(11),
		    CreditoID 		BIGINT(12),
		    ClienteID		INT(11),
		    GaranteID		INT(11),
		    ProspectoID		BIGINT(20),
		    AvalID			BIGINT(20),
		    UsuarioID		INT(11),
		    Nombre			VARCHAR(200),
		    RFC				CHAR(13),
		    Domicilio 		VARCHAR(500),
		    Identificacion	VARCHAR(30));

		insert into TMPDATOSGENERALESCONSOLFi (CreditoID,RFC)
		SELECT distinct Tm.CreditoID,Tm.RFC
		from TMPDATOSGENERALESCONSOL Tm where Tm.CreditoID=Par_CreditoID ;


		UPDATE  TMPDATOSGENERALESCONSOLFi as Fi INNER join TMPDATOSGENERALESCONSOL as Tm
		set Fi.Consecutivo=Tm.Consecutivo,Fi.Identificacion =Tm.Identificacion,Fi.Domicilio=Tm.Domicilio,Fi.RFC=Tm.RFC,Fi.Nombre=Tm.Nombre,
		    Fi.ClienteID=Tm.ClienteID,Fi.GaranteID=Tm.GaranteID,Fi.ProspectoID=Tm.ProspectoID,Fi.AvalID=Tm.AvalID,Fi.UsuarioID=Tm.UsuarioID
		where Fi.CreditoID=Par_CreditoID and Fi.RFC=Tm.RFC;


		SELECT * FROM TMPDATOSGENERALESCONSOLFi where CreditoID=Par_CreditoID ORDER by Consecutivo ;

    END IF;

    -- Lista los Garantes Relacionados al Credito
    IF(Par_TipoConsulta = Con_ListaGarantes) THEN
		 SET @Cont := 0;
		DROP TABLE IF EXISTS TMPDATOSGARANTES;
		CREATE TEMPORARY TABLE TMPDATOSGARANTES(
        Consecutivo 	INT(11),
        CreditoID 		BIGINT(12),
        ClienteID		INT(11),
        GaranteID		INT(11),
        ProspectoID		BIGINT(20),
        Nombre			VARCHAR(200),
        Domicilio 		VARCHAR(500),
		KEY `INDEX_TMPDATOSGARANTES_1` (`CreditoID`,`ClienteID`),
		KEY `INDEX_TMPDATOSGARANTES_2` (`CreditoID`,`GaranteID`),
		KEY `INDEX_TMPDATOSGARANTES_3` (`CreditoID`,`ProspectoID`));


        -- Se insertan los Garantes
		INSERT INTO TMPDATOSGARANTES
		SELECT (@Cont:=@Cont+1) AS Consecutivo, Cre.CreditoID,
			Gar.ClienteID, Gar.GaranteID, Gar.ProspectoID,'' AS Nombre,  '' AS Domicilio


			FROM  ASIGNAGARANTIAS AG
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AG.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AG.SolicitudCreditoID
                INNER JOIN GARANTIAS  Gar ON AG.GarantiaID = Gar.GarantiaID
			  WHERE Cre.CreditoID = Var_CreditoID;


        UPDATE TMPDATOSGARANTES T
        INNER JOIN CLIENTES C ON T.ClienteID = C.ClienteID
        LEFT JOIN DIRECCLIENTE D ON T.ClienteID = D.ClienteID
        AND D.Oficial = Var_SI
        LEFT JOIN IDENTIFICLIENTE I ON T.ClienteID = I.ClienteID
        SET T.Nombre = C.NombreCompleto,
			T.Domicilio = IFNULL(D.DireccionCompleta, Cadena_Vacia)
		WHERE T.CreditoID = Var_CreditoID;

		UPDATE TMPDATOSGARANTES T
        INNER JOIN GARANTES G ON T.GaranteID = G.GaranteID
        SET  T.Nombre = G.NombreCompleto,
			T.Domicilio = IFNULL(G.DireccionCompleta, Cadena_Vacia)
            WHERE T.CreditoID = Var_CreditoID;


		UPDATE TMPDATOSGARANTES T
		INNER JOIN PROSPECTOS P ON T.ProspectoID = P.ProspectoID
		SET  T.Nombre = P.NombreCompleto
            WHERE T.CreditoID = Var_CreditoID;

    	-- funcion en caso de que el garante tenga mas de una garantia en el credito y asi no se muestre su nombre dos veces

		DROP TABLE IF EXISTS TMPDATOSGARANTESCONSOLFI;
			CREATE TEMPORARY TABLE TMPDATOSGARANTESCONSOLFI(
		    Consecutivo 	INT(11),
		    CreditoID 		BIGINT(12),
		    ClienteID		INT(11),
		    GaranteID		INT(11),
		    ProspectoID		BIGINT(20),
		    Nombre			VARCHAR(200),
		    Domicilio 		VARCHAR(500));
		insert into TMPDATOSGARANTESCONSOLFI (CreditoID,ClienteID, GaranteID ,ProspectoID)
		SELECT distinct Tm.CreditoID, Tm.ClienteID, Tm.GaranteID ,Tm.ProspectoID
		from TMPDATOSGARANTES Tm where Tm.CreditoID=Par_CreditoID ;


		UPDATE  TMPDATOSGARANTESCONSOLFI as Fi INNER join TMPDATOSGARANTES as Tm
		on(Fi.ClienteID=Tm.ClienteID and Fi.GaranteID=Tm.GaranteID   and Fi.ProspectoID=Tm.ProspectoID)
		set Fi.Consecutivo=Tm.Consecutivo,Fi.Domicilio=Tm.Domicilio,Fi.Nombre=Tm.Nombre
		where Fi.CreditoID=Par_CreditoID ;


		SELECT * FROM TMPDATOSGARANTESCONSOLFI where CreditoID=Par_CreditoID  ;


	END IF;
	
	-- Lista los Avales Relacionados al Credito
    IF(Par_TipoConsulta = Con_ListaAvales) THEN
		 SET @Cont := 0;
		DROP TABLE IF EXISTS TMPDATOSAVALES;
		CREATE TEMPORARY TABLE TMPDATOSAVALES(
        Consecutivo 	INT(11),
        CreditoID 		BIGINT(12),
        ClienteID		INT(11),
        ProspectoID		BIGINT(20),
        AvalID			BIGINT(20),
        Nombre			VARCHAR(200),
        Domicilio 		VARCHAR(500),
		KEY `INDEX_TMPDATOSAVALES_1` (`CreditoID`,`ClienteID`),
		KEY `INDEX_TMPDATOSAVALES_2` (`CreditoID`,`ProspectoID`),
		KEY `INDEX_TMPDATOSAVALES_3` (`CreditoID`,`AvalID`));


      -- Se insertan los Avales
      INSERT INTO TMPDATOSAVALES
      SELECT (@Cont:=@Cont+1) AS Consecutivo, Cre.CreditoID,
			AP.ClienteID,   AP.ProspectoID,  AP.AvalID, '' AS Nombre, '' AS Domicilio

			FROM  AVALESPORSOLICI AP
				INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
				INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
			  WHERE Cre.CreditoID = Var_CreditoID;



        UPDATE TMPDATOSAVALES T
        INNER JOIN CLIENTES C ON T.ClienteID = C.ClienteID
        LEFT JOIN DIRECCLIENTE D ON T.ClienteID = D.ClienteID
        AND D.Oficial = Var_SI
        LEFT JOIN IDENTIFICLIENTE I ON T.ClienteID = I.ClienteID
        SET T.Nombre = C.NombreCompleto,
			T.Domicilio = IFNULL(D.DireccionCompleta, Cadena_Vacia)
		WHERE T.CreditoID = Var_CreditoID;


		UPDATE TMPDATOSAVALES T
        INNER JOIN AVALES A ON T.AvalID = A.AvalID
        SET  T.Nombre = IFNULL(A.NombreCompleto, Cadena_Vacia),
			T.Domicilio = IFNULL(A.DireccionCompleta, Cadena_Vacia)
		WHERE T.CreditoID = Var_CreditoID;



		UPDATE TMPDATOSAVALES T
		INNER JOIN PROSPECTOS P ON T.ProspectoID = P.ProspectoID
		SET  T.Nombre = IFNULL(P.NombreCompleto, Cadena_Vacia)
            WHERE T.CreditoID = Var_CreditoID;

    	-- funcion en caso de que el garante tenga mas de una garantia en el credito y asi no se muestre su nombre dos veces

   		DROP TABLE IF EXISTS TMPDATOSAVALESCONSOLFI;
		CREATE TEMPORARY TABLE TMPDATOSAVALESCONSOLFI(
	    Consecutivo 	INT(11),
	    CreditoID 		BIGINT(12),
	    ClienteID		INT(11),
	    AvalID		INT(11),
	    ProspectoID		BIGINT(20),
	    Nombre			VARCHAR(200),
	    Domicilio 		VARCHAR(500));
		insert into TMPDATOSAVALESCONSOLFI (CreditoID,ClienteID, AvalID ,ProspectoID)
		SELECT distinct Tm.CreditoID, Tm.ClienteID, Tm.AvalID ,Tm.ProspectoID
		from TMPDATOSAVALES Tm where Tm.CreditoID=Par_CreditoID ;


		UPDATE  TMPDATOSAVALESCONSOLFI as Fi INNER join TMPDATOSAVALES as Tm
		on(Fi.ClienteID=Tm.ClienteID and Fi.AvalID=Tm.AvalID   and Fi.ProspectoID=Tm.ProspectoID)
		set Fi.Consecutivo=Tm.Consecutivo,Fi.Domicilio=Tm.Domicilio,Fi.Nombre=Tm.Nombre
		where Fi.CreditoID=Par_CreditoID ;


		SELECT * FROM TMPDATOSAVALESCONSOLFI where CreditoID=Par_CreditoID  ;


	END IF;

	-- Lista los usuarios Relacionados al Credito
    IF(Par_TipoConsulta = Con_ListaUsuarios) THEN
		 SET @Cont := 0;
		DROP TABLE IF EXISTS TMPDATOSUSUARIOS;
		CREATE TEMPORARY TABLE TMPDATOSUSUARIOS(
        Consecutivo 	INT(11),
        CreditoID 		BIGINT(12),
        UsuarioID		INT(11),
        EmpleadoID       BIGINT(20),
        Nombre			VARCHAR(200),
        Domicilio 		VARCHAR(500),
		KEY `INDEX_TMPDATOSUSUARIOS_1` (`CreditoID`,`UsuarioID`,`EmpleadoID`));


      -- Se insertan el USUARIO que es GERENTE de la SUCURSAL
        SET Var_SucursalUsuario := (SELECT SucursalID FROM CREDITOS U WHERE CreditoID = Var_CreditoID);

        INSERT INTO TMPDATOSUSUARIOS
        SELECT  (@Cont:=@Cont+1) AS Consecutivo, Var_CreditoID,U.UsuarioID,U.EmpleadoID,
				U.NombreCompleto,	IFNULL(U.DireccionCompleta,'')
			FROM USUARIOS U
			INNER JOIN SUCURSALES S
			ON U.UsuarioID = S.NombreGerente
			WHERE S.SucursalID = Var_SucursalUsuario ;


		INSERT INTO TMPDATOSUSUARIOS
        SELECT  (@Cont:=@Cont+1) AS Consecutivo, Var_CreditoID,U.UsuarioID,U.EmpleadoID,
				U.NombreCompleto,	IFNULL(U.DireccionCompleta,'')
			FROM USUARIOS U
			INNER JOIN SUCURSALES S
			ON U.UsuarioID = S.SubGerente
			WHERE S.SucursalID = Var_SucursalUsuario ;

	    UPDATE 	TMPDATOSUSUARIOS AS TmUsu INNER JOIN EMPLEADOS as Em 
	    ON TmUsu.EmpleadoID=Em.EmpleadoID
	    SET TmUsu.Nombre=Em.NombreCompleto
	    where TmUsu.EmpleadoID is not null and TmUsu.CreditoID=Var_CreditoID;


		SELECT * FROM TMPDATOSUSUARIOS;

	END IF;

    -- Datos Generales Agro.
    IF(Par_TipoConsulta = Con_GeneralesAgro)THEN
		-- Nombre Comercial del producto de crédito.
		SELECT 	 P.NombreComercial, C.SolicitudCreditoID
			INTO Var_NombreProd,	Var_SolicitudCreditoID
			FROM CREDITOS C
			INNER JOIN PRODUCTOSCREDITO P ON P.ProducCreditoID = C.ProductoCreditoID
			WHERE C.CreditoID = Par_CreditoID;

        -- Monto total de la deuda.
        SET Var_EstatusCred := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Var_CreditoID);
        IF(Var_EstatusCred = 'I' OR Var_EstatusCred = 'A') THEN
			SET Var_MontoDeuda :=
				(SELECT CONVPORCANT(SUM(A.Capital + A.Interes + A.IVAInteres), '$C', 'PESOS', 'NACIONAL')
					  FROM AMORTICREDITO AS A
						WHERE A.CreditoID = Var_CreditoID
                        GROUP BY A.CreditoID);
		ELSE
			SET Var_MontoDeuda :=
				(SELECT CONVPORCANT(SUM(P.Capital + P.Interes + P.IVAInteres), '$C', 'PESOS', 'NACIONAL') AS MontoCuota
					  FROM PAGARECREDITO AS P
						WHERE P.CreditoID = Var_CreditoID
                        GROUP BY P.CreditoID);
        END IF;

        -- Total Conceptos de inversión
		SET Var_MontoTotConcepInv := (
			SELECT SUM(Monto)
				FROM CONCEPTOINVERAGRO I
				INNER JOIN CREDITOS C ON C.SolicitudCreditoID = I.SolicitudCreditoID
				WHERE C.CreditoID = Var_CreditoID);

		-- Conceptos de inversión por tipo Prestamo
        SET Var_RecursoPrestConInv := (
			SELECT SUM(Monto)
				FROM CONCEPTOINVERAGRO I
				INNER JOIN CREDITOS C ON C.SolicitudCreditoID = I.SolicitudCreditoID
				WHERE I.TipoRecurso = 'P'
					AND C.CreditoID = Var_CreditoID);

        -- Conceptos de inversión por tipo Solicitante
        SET Var_RecursoSoliConInv := (
			SELECT SUM(Monto)
				FROM CONCEPTOINVERAGRO I
				INNER JOIN CREDITOS C ON C.SolicitudCreditoID = I.SolicitudCreditoID
				WHERE I.TipoRecurso = 'S'
					AND C.CreditoID = Var_CreditoID);

        -- Conceptos de inversión por tipo Otros
        SET Var_OtrosRecConInv := (
			SELECT SUM(Monto)
				FROM CONCEPTOINVERAGRO I
				INNER JOIN CREDITOS C ON C.SolicitudCreditoID = I.SolicitudCreditoID
				WHERE I.TipoRecurso = 'OF'
					AND C.CreditoID = Var_CreditoID);

		-- Relación de la garantía.
		SELECT   MAX(Proporcion), 	FNDECIMALALETRA(MAX(Proporcion), Entero_Cero)
			INTO Var_ProporcionGar, Var_ProporcionLetra
			FROM      CREDITOS Cre
				INNER JOIN  ASIGNAGARANTIAS Asi ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
				INNER JOIN  GARANTIAS Gar ON Gar.GarantiaID = Asi.GarantiaID
			WHERE Cre.CreditoID = Var_CreditoID;

		-- Se regresan los datos
		SELECT
			IFNULL(Var_NombreProd,Cadena_Vacia) AS NombreProd,
			IFNULL(Var_MontoDeuda,Entero_Cero) AS MontoDeuda,
			IFNULL(Var_MontoTotConcepInv,Entero_Cero) AS MontoTotConcepInv,
			IFNULL(Var_RecursoPrestConInv,Entero_Cero) AS RecursoPrestConInv,
			IFNULL(Var_RecursoSoliConInv,Entero_Cero) AS RecursoSoliConInv,
			IFNULL(Var_OtrosRecConInv,Entero_Cero) AS OtrosRecConInv,
			IFNULL(Var_ProporcionGar,Entero_Cero) AS ProporcionGar,
			IFNULL(Var_ProporcionLetra,Cadena_Vacia) AS ProporcionLetra,
			IFNULL(Var_SolicitudCreditoID,Cadena_Vacia) AS SolicitudCreditoID;

    END IF;

    -- Porcentajes de garantías FIRA.
	IF(Par_TipoConsulta = Con_ListaPorcentGarFIRA) THEN
		SELECT 	TipoGarantiaID, ClasificacionID,
				CONVPORCANT(IFNULL(Porcentaje, 0.00), Var_FormatoTasaConsol, '2', '') AS Porcentaje
			FROM GARANTIASFIRA;
    END IF;

    -- Lista el calendario de ministraciones.
    IF(Par_TipoConsulta = Con_ListaMinistracion)THEN
		SELECT 	Numero, CONCAT(FNFECHATEXTO(FechaMinistracion)) AS FechaMinistracion,
				CONVPORCANT((IFNULL(Capital, Decimal_Cero)), Var_FormatoPesoConsol, 'Peso', 'Nacional') AS Capital
			FROM MINISTRACREDAGRO
			WHERE CreditoID = Var_CreditoID;
    END IF;

    -- Lista las garantías y garantes.
    IF(Par_TipoConsulta = Con_ListaGarantiasGaran)THEN
		DROP TABLE IF EXISTS TMPGARANTIAUSUFRUC;
		CREATE TEMPORARY TABLE TMPGARANTIAUSUFRUC(
			GarantiaID 		INT(11),
            Observaciones 	VARCHAR(1200),
            Figura			CHAR(1),
            GaranteID		INT(11),
            TipoPersona		CHAR(1),
            NombreGarante	VARCHAR(200),
            Alias			VARCHAR(200),
            Usufructuaria	CHAR(1),
            TipoGarantia	INT(1),
            PRIMARY KEY (GarantiaID)
        );
		INSERT INTO TMPGARANTIAUSUFRUC
		SELECT  Gar.GarantiaID, Observaciones, 	Cadena_Vacia, 	Entero_Cero, 	Cadena_Vacia,
				Cadena_Vacia, 	Cadena_Vacia,	Usufructuaria,	TipoGarantiaID
			FROM      CREDITOS Cre
			INNER JOIN  ASIGNAGARANTIAS Asi   ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
			INNER JOIN  GARANTIAS Gar     ON Gar.GarantiaID = Asi.GarantiaID
				  WHERE Cre.CreditoID = Var_CreditoID;

        -- Actualiza la figura del garante.
        UPDATE TMPGARANTIAUSUFRUC T
			INNER JOIN GARANTIAS G ON G.GarantiaID = T.GarantiaID
            SET
			T.Figura 	= IFNULL(CASE WHEN G.ClienteID > Entero_Cero 	THEN Var_FiguraCliente
                                      WHEN G.ProspectoID > Entero_Cero 	THEN Var_FiguraProspecto
                                      WHEN G.AvalID > Entero_Cero 		THEN Var_FiguraAval
                                      WHEN G.GaranteID > Entero_Cero 	THEN Var_FiguraGarante
								 END, Cadena_Vacia),
			T.GaranteID = IFNULL(CASE WHEN G.ClienteID > Entero_Cero 	THEN G.ClienteID
                                      WHEN G.ProspectoID > Entero_Cero 	THEN G.ProspectoID
                                      WHEN G.AvalID > Entero_Cero 		THEN G.AvalID
                                      WHEN G.GaranteID > Entero_Cero 	THEN G.GaranteID
								 END, Entero_Cero);

		-- Actualiza nombre cuando el garante es cliente.
        UPDATE TMPGARANTIAUSUFRUC T
			INNER JOIN CLIENTES C ON C.ClienteID = T.GaranteID
            LEFT JOIN INCONSISTENCIAS I ON I.ClienteID = T.GaranteID
            SET T.NombreGarante = C.NombreCompleto,
				T.TipoPersona	= C.TipoPersona,
                T.Alias			= IFNULL(I.NombreCompleto,Cadena_Vacia)
			WHERE T.Figura = Var_FiguraCliente;

        -- Actualiza nombre cuando el garante es prospecto.
        UPDATE TMPGARANTIAUSUFRUC T
			INNER JOIN PROSPECTOS P ON P.ProspectoID = T.GaranteID
            LEFT JOIN INCONSISTENCIAS I ON I.ProspectoID = T.GaranteID
            SET T.NombreGarante = P.NombreCompleto,
				T.TipoPersona	= P.TipoPersona,
                T.Alias			= IFNULL(I.NombreCompleto,Cadena_Vacia)
			WHERE T.Figura = Var_FiguraProspecto;

        -- Actualiza nombre cuando el garante es Aval.
        UPDATE TMPGARANTIAUSUFRUC T
			INNER JOIN AVALES A ON A.AvalID = T.GaranteID
            LEFT JOIN INCONSISTENCIAS I ON I.AvalID = T.GaranteID
            SET T.NombreGarante = A.NombreCompleto,
				T.TipoPersona	= A.TipoPersona,
                T.Alias			= IFNULL(I.NombreCompleto,Cadena_Vacia)
			WHERE T.Figura = Var_FiguraAval;

        -- Actualiza nombre cuando el garante es Garante.
        UPDATE TMPGARANTIAUSUFRUC T
			INNER JOIN GARANTES G ON G.GaranteID = T.GaranteID
            LEFT JOIN INCONSISTENCIAS I ON I.GaranteID = T.GaranteID
            SET T.NombreGarante = G.NombreCompleto,
				T.TipoPersona	= G.TipoPersona,
                T.Alias			= IFNULL(I.NombreCompleto,Cadena_Vacia)
			WHERE T.Figura = Var_FiguraGarante;


		SELECT 	GarantiaID, 	Observaciones, 	Figura, 		GaranteID, 	TipoPersona,
				NombreGarante, 	Alias,			Usufructuaria,	TipoGarantia
			FROM TMPGARANTIAUSUFRUC;
    END IF;

	-- Lista de miembros del consejo de administración del cliente.
	IF(Par_TipoConsulta = Con_ListaConsejoAdmon)THEN
		DROP TABLE IF EXISTS TMP_DIRECTIVOS;
		CREATE TEMPORARY TABLE TMP_DIRECTIVOS(
			DirectivoID 	INT (11),
			CargoID			INT (11),
			NombreCargo		VARCHAR (100),
			Direccion		VARCHAR (250),
			PersonaID		INT (11),
			TipoDirectivo	CHAR (1),    
			NombreCompleto	VARCHAR (150),
			Identificacion	VARCHAR (20),
			Alias			VARCHAR (150),
			
			PRIMARY KEY (DirectivoID)
		);

		SELECT ClienteID
			INTO Var_ClienteID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;    

		INSERT INTO TMP_DIRECTIVOS
		SELECT DirectivoID, D.CargoID, C.Descripcion, D.Domicilio,
				IFNULL(CASE WHEN D.RelacionadoID > Entero_Cero 	THEN D.RelacionadoID
							WHEN D.GaranteRelacion > Entero_Cero 	THEN D.GaranteRelacion
							WHEN D.AvalRelacion > Entero_Cero 		THEN D.AvalRelacion
							WHEN D.PersonaID > Entero_Cero 		THEN D.PersonaID
					END, Entero_Cero) AS PersonaID,
				IFNULL(CASE WHEN D.RelacionadoID > Entero_Cero 	THEN Var_FiguraCliente
							WHEN D.GaranteRelacion > Entero_Cero 	THEN Var_FiguraGarante
							WHEN D.AvalRelacion > Entero_Cero 		THEN Var_FiguraAval
							WHEN D.PersonaID > Entero_Cero 		THEN Var_FirguraPersona
					END, Cadena_Vacia) AS TipoDirectivo,
				IFNULL(CASE WHEN D.RelacionadoID  > Entero_Cero 	THEN Cte.NombreCompleto
							WHEN D.RelacionadoID  <= Entero_Cero 	THEN D.NombreCompleto
					END, Cadena_Vacia) AS NombreCompleto,
				IFNULL(CASE WHEN D.RelacionadoID  > Entero_Cero 	THEN I.NumIdentific
							WHEN D.RelacionadoID  <= Entero_Cero 	THEN D.NumIdentific
					END, Cadena_Vacia) AS NumIdentific, Cadena_Vacia
			FROM DIRECTIVOS D
			LEFT JOIN CLIENTES Cte ON Cte.ClienteID = D.RelacionadoID
			LEFT JOIN IDENTIFICLIENTE I ON I.ClienteID = D.RelacionadoID AND I.IdentificID = 1
			LEFT JOIN CATCARGOS C ON C.CargoID = D.CargoID
			WHERE D.ClienteID = Var_ClienteID;

		-- Actualización de direcciones de directivos como clientes
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = D.PersonaID AND Dir.Oficial = 'S'
			SET D.Direccion = Dir.DireccionCompleta
			WHERE D.TipoDirectivo = Var_FiguraCliente;
				
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN AVALES A ON A.AvalID = D.PersonaID
			SET D.Direccion = A.DireccionCompleta
			WHERE D.TipoDirectivo = Var_FiguraAval;
				
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN GARANTES G ON G.GaranteID = D.PersonaID
			SET D.Direccion = G.DireccionCompleta
			WHERE D.TipoDirectivo = Var_FiguraGarante;

		-- Actualización de Alias de directivos.
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN INCONSISTENCIAS I ON I.ClienteID = D.PersonaID
			SET D.Alias= I.NombreCompleto
			WHERE D.TipoDirectivo = Var_FiguraCliente;
				
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN INCONSISTENCIAS I ON I.AvalID = D.PersonaID
			SET D.Alias= I.NombreCompleto
			WHERE D.TipoDirectivo = Var_FiguraAval;
				
		UPDATE TMP_DIRECTIVOS D
			INNER JOIN INCONSISTENCIAS I ON I.GaranteID = D.PersonaID
			SET D.Alias= I.NombreCompleto
			WHERE D.TipoDirectivo = Var_FiguraGarante;

		SELECT 	DirectivoID, 	CargoID, 			NombreCargo,	Direccion,	PersonaID,
				TipoDirectivo,  NombreCompleto,		Identificacion,	Alias
			FROM TMP_DIRECTIVOS;

	END IF;
	
	-- Consulta de información de escrituras públicas.
	IF(Par_TipoConsulta = Con_Escrituras)THEN

		SELECT ClienteID INTO Var_ClienteID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID; 

		SELECT S.Descripcion INTO Var_TipoSociedad
			FROM CLIENTES C 
			INNER JOIN TIPOSOCIEDAD S ON S.TipoSociedadID = C.TipoSociedadID
			WHERE ClienteID = Var_ClienteID;
		
		SELECT 	E.EscrituraPublic, 		E.FechaEsc, 			E.Notaria, 				N.Titular, 			M.Nombre,
				R.Nombre, 				N.Direccion, 			E.FolioRegPub
			INTO Var_EscPublicPM,		Var_FechaEscPM,			Var_NotariaPM,			Var_NombreNotarioPM,		Var_MunicipioNotariaPM,
				Var_EstadoNotariaPM,	Var_DireccionNotariaPM,	Var_FolioMercantilPM
			FROM ESCRITURAPUB E
			INNER JOIN NOTARIAS N ON N.NotariaID = E.Notaria
			LEFT JOIN MUNICIPIOSREPUB M ON M.EstadoID = N.EstadoID AND M.MunicipioID = N.MunicipioID
			LEFT JOIN ESTADOSREPUB R ON R.EstadoID = N.EstadoID AND R.EstadoID = M.EstadoID
			WHERE ClienteID = Var_ClienteID
				AND Esc_Tipo = 'C'
				LIMIT 1;

		SELECT 	D.NumEscPub, 		C.Descripcion, 		D.NombreCompleto, 			D.FechaEscPub,		D.NotariaID, 
				D.TitularNotaria, 	E.Nombre, 			D.FolioMercantil
			INTO Var_NumEscPub,		Var_CargoRepLegal,	Var_NomRepresentanteLeg,	Var_FechaEscPub,	Var_NumNotariaPub,
				Var_NombreNotario,	Var_NomEstadoEscPub,	Var_FolioMercantil
			FROM DIRECTIVOS D
				INNER JOIN CATCARGOS C ON C.CargoID = D.CargoID
				LEFT JOIN ESTADOSREPUB E ON E.EstadoID = D.EstadoID
			WHERE D.ClienteID = Var_ClienteID
				AND D.CargoID = 1;

		SELECT 
			IFNULL(Var_TipoSociedad, Cadena_Vacia) AS TipoSociedad,
			IFNULL(Var_EscPublicPM, Cadena_Vacia) AS EscPublicPM,
			IFNULL(FNFECHACOMPLETA(Var_FechaEscPM,3), Cadena_Vacia) AS FechaEscPM,
			IFNULL(Var_NotariaPM, Cadena_Vacia) AS NotariaPM,
			IFNULL(Var_NombreNotarioPM, Cadena_Vacia) AS NombreNotarioPM,
			IFNULL(Var_MunicipioNotariaPM, Cadena_Vacia) AS MunicipioNotariaPM,
			IFNULL(Var_EstadoNotariaPM, Cadena_Vacia) AS EstadoNotariaPM,
			IFNULL(Var_DireccionNotariaPM, Cadena_Vacia) AS DireccionNotariaPM,
			IFNULL(Var_FolioMercantilPM, Cadena_Vacia) AS FolioMercantilPM,
			IFNULL(Var_NumEscPub, Cadena_Vacia) AS NumEscPub,
			IFNULL(Var_CargoRepLegal, Cadena_Vacia) AS CargoRepLegal,
			IFNULL(Var_NomRepresentanteLeg, Cadena_Vacia) AS NomRepresentanteLeg,
			IFNULL(FNFECHACOMPLETA(Var_FechaEscPub,3), Cadena_Vacia) AS FechaEscPub,
			IFNULL(Var_NumNotariaPub, Cadena_Vacia) AS NumNotariaPub,
			IFNULL(Var_NombreNotario, Cadena_Vacia) AS NombreNotario,
			IFNULL(Var_NomEstadoEscPub, Cadena_Vacia) AS NomEstadoEscPub,
			IFNULL(Var_FolioMercantil, Cadena_Vacia) AS FolioMercantil;


	END IF;

END TerminaStore$$