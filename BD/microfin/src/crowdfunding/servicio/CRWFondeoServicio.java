package crowdfunding.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import crowdfunding.bean.CRWFondeoBean;
import crowdfunding.dao.CRWFondeoDAO;

import java.util.Iterator;
import java.util.List;

public class CRWFondeoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CRWFondeoDAO crwFondeoDAO = null;


	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Fondeo {
		int principal = 1;
		int gridFondeador = 2;
		int gridInversiones = 3;
		int saldosYpagos = 4;
		int InvXCliente = 6;
	}


//---------- tipos Transacciones ------------------------------------------------------------------------

	public static interface Enum_Tra_Fondeo  {
		int alta = 1;
	}

//---------- tipos Consulta ------------------------------------------------------------------------

	public static interface Enum_Con_Fondeo  {
		int principal = 1;
		int misInversiones = 2;
		int detalleInversiones = 3;
		int CalificPorcen 	= 4;
		int PlazoPorcen 	= 5;
		int TasaPonxCalif	= 6;
		int saldosYpagos = 7;
	}




	public CRWFondeoBean consulta(int tipoConsulta, CRWFondeoBean crwFondeoBean){
		CRWFondeoBean crwFondeo = null;
		switch (tipoConsulta) {
			case Enum_Con_Fondeo.principal:
				crwFondeo = crwFondeoDAO.consultaPrincipal(crwFondeoBean, tipoConsulta);
			break;
		}
		return crwFondeo;
	}




	public List listaGrid(int tipoLista,CRWFondeoBean crwFondeo){
		List listaFondeos = null;
		switch (tipoLista) {
			case Enum_Lis_Fondeo.principal:
				//listaFondeos = fondeoSolicitudDAO.listaPrincipal(fondeoSolicitud, tipoLista);
				break;
			case Enum_Lis_Fondeo.saldosYpagos:		// lista de fondeadores Para pantalla de alta de credito kubo
				listaFondeos = crwFondeoDAO.listaGridSaldosYpagos(crwFondeo, tipoLista);
				break;
			case Enum_Lis_Fondeo.InvXCliente:
				listaFondeos = crwFondeoDAO.listaXInvCliente(crwFondeo, tipoLista);
				break;
		}
		return listaFondeos;
	}

	public CRWFondeoDAO getCrwFondeoDAO() {
		return crwFondeoDAO;
	}

	public void setCrwFondeoDAO(CRWFondeoDAO crwFondeoDAO) {
		this.crwFondeoDAO = crwFondeoDAO;
	}

/*
	public Object consultaMisInversionesWS(int tipoConsulta, Object consultaInversionesBean){
		Object obj= null;
		switch (tipoConsulta) {
		case Enum_Con_Fondeo.misInversiones:
			ConsultaInversionesRequest consultaRequest = (ConsultaInversionesRequest)consultaInversionesBean;
			ConsultaInversionesResponse consultaResponse=null;
			consultaResponse= crwFondeoDAO.consultaMisInversiones(consultaRequest);
			if(consultaResponse == null) {
				consultaResponse = new ConsultaInversionesResponse();
				Utileria.escribelog("el resultado es nulo");
				consultaResponse.setGananciaAnuTot(Constantes.STRING_CERO);
				consultaResponse.setNumInteresCobrado(Constantes.STRING_CERO);
				consultaResponse.setInteresCobrado(Constantes.STRING_CERO);
				consultaResponse.setPagTotalRecib(Constantes.STRING_CERO);
				consultaResponse.setSaldoTotal(Constantes.STRING_CERO);
				consultaResponse.setNumeroEfectivoDispon(Constantes.STRING_CERO);
				consultaResponse.setSaldoEfectivoDispon(Constantes.STRING_CERO);
				consultaResponse.setNumeroInverEnProceso(Constantes.STRING_CERO);
				consultaResponse.setSaldoInverEnProceso(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvActivas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvActivas(Constantes.STRING_CERO);
				consultaResponse.setNumeroIntDevengados(Constantes.STRING_CERO);
				consultaResponse.setSaldoIntDevengados(Constantes.STRING_CERO);
				consultaResponse.setNumeroTotInversiones(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvActivasResumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvActivasResumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas1a15Resumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas1a15Resumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas16a30Resumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas16a30Resumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas31a90Resumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas31a90Resumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvVencidas91a120Resumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvVencidas91a120Resumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvVencidas121a180Resumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvVencidas121a180Resumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvQuebrantadasResumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvQuebrantadasResumen(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvLiquidadasResumen(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvLiquidadasResumen(Constantes.STRING_CERO);
				consultaResponse.setNumCapitalCobrado(Constantes.STRING_CERO);
				consultaResponse.setCapitalCobrado(Constantes.STRING_CERO);
				consultaResponse.setNumMoraCobrado(Constantes.STRING_CERO);
				consultaResponse.setMoraCobrado(Constantes.STRING_CERO);
				consultaResponse.setNumComFalPago(Constantes.STRING_CERO);
				consultaResponse.setComFalPago(Constantes.STRING_CERO);
				consultaResponse.setCodigoRespuesta(Constantes.STRING_CERO);
				consultaResponse.setMensajeRespuesta(Constantes.STRING_CERO);
				consultaResponse.setGatReal(Constantes.STRING_CERO);
			}

			obj=(Object)consultaResponse;

			break;
		}
		return obj;
	}

	public Object consultaDetalleInverKuboWS(int tipoConsulta, Object consultaDetalleInversionesBean){
		Object obj= null;
		String cadena;
		switch (tipoConsulta) {
		case Enum_Con_Fondeo.detalleInversiones:
			ConsultaDetalleInverRequest consultaRequest = (ConsultaDetalleInverRequest)consultaDetalleInversionesBean;
			ConsultaDetalleInverResponse consultaResponse=null;
			consultaResponse= crwFondeoDAO.consultaDetalleInversionesKuboWS(consultaRequest, tipoConsulta);

			if(consultaResponse == null) {
				consultaResponse = new ConsultaDetalleInverResponse();
				Utileria.escribelog("el resultado es nulo");

				consultaResponse.setNumeroInverEnProceso(Constantes.STRING_CERO);
				consultaResponse.setSaldoInverEnProceso(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvActivas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvActivas(Constantes.STRING_CERO);
				consultaResponse.setNumeroTotInversiones(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvActivas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvActivas(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas1a15(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas1a15(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas16a30(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas16a30(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvAtrasadas31a90(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvAtrasadas31a90(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvVencidas91a120(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvVencidas91a120(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvVencidas121a180(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvVencidas121a180(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvQuebrantadas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvQuebrantadas(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvLiquidadas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvLiquidadas(Constantes.STRING_CERO);
				consultaResponse.setTasaPonderada(Constantes.STRING_CERO);
				consultaResponse.setNumeroIntDev(Constantes.STRING_CERO);
				consultaResponse.setSaldoIntDev(Constantes.STRING_CERO);
				consultaResponse.setNumPagosRecibidos(Constantes.STRING_CERO);
				consultaResponse.setSalPagosRecibidos(Constantes.STRING_CERO);
				consultaResponse.setNumPagosCapital(Constantes.STRING_CERO);
				consultaResponse.setSalPagosCapital(Constantes.STRING_CERO);
				consultaResponse.setNumPagosInterOrdi(Constantes.STRING_CERO);
				consultaResponse.setSalPagosInterOrdi(Constantes.STRING_CERO);
				consultaResponse.setNumPagosInteMora(Constantes.STRING_CERO);
				consultaResponse.setSalPagosInteMora(Constantes.STRING_CERO);
				consultaResponse.setImpuestos(Constantes.STRING_CERO);
				consultaResponse.setComisPagadas(Constantes.STRING_CERO);
				consultaResponse.setNumComisRecibidas(Constantes.STRING_CERO);
				consultaResponse.setSalComisRecibidas(Constantes.STRING_CERO);
				consultaResponse.setNumEfecDisp(Constantes.STRING_CERO);
				consultaResponse.setSalEfecDisp(Constantes.STRING_CERO);
				consultaResponse.setNumeroInvActivas(Constantes.STRING_CERO);
				consultaResponse.setSaldoInvActivas(Constantes.STRING_CERO);
				consultaResponse.setNumeroIntDev(Constantes.STRING_CERO);
				consultaResponse.setSaldoIntDev(Constantes.STRING_CERO);
				consultaResponse.setDepositos(Constantes.STRING_CERO);
				consultaResponse.setInverRealiz(Constantes.STRING_CERO);
				consultaResponse.setPagCapRecib(Constantes.STRING_CERO);
				consultaResponse.setIntOrdRec(Constantes.STRING_CERO);
				consultaResponse.setIntMoraRec(Constantes.STRING_CERO);
				consultaResponse.setRecupMorosos(Constantes.STRING_CERO);
				consultaResponse.setISRretenido(Constantes.STRING_CERO);
				consultaResponse.setComisCobrad(Constantes.STRING_CERO);
				consultaResponse.setComisPagad(Constantes.STRING_CERO);
				consultaResponse.setAjustes(Constantes.STRING_CERO);
				consultaResponse.setQuebrantos(Constantes.STRING_CERO);
				consultaResponse.setQuebranXapli(Constantes.STRING_CERO);
				consultaResponse.setPremiosRecom(Constantes.STRING_CERO);
				consultaResponse.setCodigoRespuesta(Constantes.STRING_CERO);
				consultaResponse.setMensajeRespuesta(Constantes.STRING_CERO);
			}

			List<ConsultaDetalleInverResponse> tmpLisCalPor = crwFondeoDAO.listaInvkuboXcalificPorc(consultaRequest, Enum_Con_Fondeo.CalificPorcen );
			List<ConsultaDetalleInverResponse> tmpLisPlazoPor = crwFondeoDAO.listaInvkuboXplazoPorcentaje(consultaRequest, Enum_Con_Fondeo.PlazoPorcen );
			List<ConsultaDetalleInverResponse> tmpLisTasaxCal = crwFondeoDAO.listaInvkuboTasasPonXcalif(consultaRequest, Enum_Con_Fondeo.TasaPonxCalif );


			if (tmpLisCalPor!=null){
					cadena=transformArray(tmpLisCalPor);
					consultaResponse.setInfoCalifPorc(cadena);
					Utileria.escribelog("devolviendo valores de lista de inv por calific");
			} else
			{
				consultaResponse.setInfoCalifPorc(Constantes.STRING_CERO);

			}
			if (tmpLisPlazoPor!=null){
				cadena=transformArrayPlazo(tmpLisPlazoPor);
				consultaResponse.setInfoPlazosPorc(cadena);
				Utileria.escribelog("lista plazo "+cadena);
			} else
			{
			consultaResponse.setInfoPlazosPorc(Constantes.STRING_CERO);
			}
			if (tmpLisTasaxCal!=null){
				cadena=transformArrayTasa(tmpLisTasaxCal);
				consultaResponse.setInfoTasasPonCalif(cadena);
				Utileria.escribelog("lista tasas en servicio "+cadena);
			} else
			{
			consultaResponse.setInfoTasasPonCalif(Constantes.STRING_CERO);
			}

			obj=(Object)consultaResponse;

			break;
		}
		return obj;
	}


	private String transformArray(List  a)
    {
		//Utileria.escribelog("dentro transform Array");
        String consultaResponse ="";
        ConsultaDetalleInverResponse temp;

        if(a!=null)
        {   //res = new String[a.size()];
            Iterator<ConsultaDetalleInverResponse> it = a.iterator();
            while(it.hasNext())
            {
                temp = (ConsultaDetalleInverResponse)it.next();

                consultaResponse+= temp.getInfoCalifPorc()+"&|&";

            }
        }
        return consultaResponse;
    }
	/*para la lista de inv kubo por plazo y porcentaje
	private String transformArrayPlazo(List  a)
    {
		//Utileria.escribelog("dentro transform Array");
        String consultaResponse ="";
        ConsultaDetalleInverResponse temp;

        if(a!=null)
        {
            Iterator<ConsultaDetalleInverResponse> it = a.iterator();
            while(it.hasNext())
            {
                temp = (ConsultaDetalleInverResponse)it.next();
               consultaResponse+= temp.getInfoPlazosPorc()+"&|&";

            }
        }
        return consultaResponse;
    }

	/*para la lista de inv kubo de tasas ponderados por calificacion

	private String transformArrayTasa(List  a)
    {
		//Utileria.escribelog("dentro transform Array");
        String consultaResponse ="";
        ConsultaDetalleInverResponse temp;

        if(a!=null)
        {
            Iterator<ConsultaDetalleInverResponse> it = a.iterator();
            while(it.hasNext())
            {
                temp = (ConsultaDetalleInverResponse)it.next();
                consultaResponse+= temp.getInfoTasasPonCalif()+"&|&";
            }
        }
        return consultaResponse;
    }
*/

}