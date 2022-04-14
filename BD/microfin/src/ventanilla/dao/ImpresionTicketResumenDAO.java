package ventanilla.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import ventanilla.bean.ImpresionTicketResumenBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ImpresionTicketResumenDAO extends BaseDAO {

	public ImpresionTicketResumenDAO(){
		super();
	}

	// Consulta Principal
	public ImpresionTicketResumenBean consultaPrincipal(final ImpresionTicketResumenBean impresionTicketResumenBean, final int tipoConsulta) {

		ImpresionTicketResumenBean impresionTicketResumenBeanResponse = null;
		//Query con el Store Procedure
		try{
			String query = "CALL IMPTICKETRESUMENCON(?,?,"
										    	   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(impresionTicketResumenBean.getOpcionCajaID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ImpresionTicketResumenDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL IMPTICKETRESUMENCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ImpresionTicketResumenBean impresionTicket = new ImpresionTicketResumenBean();

					impresionTicket.setOpcionCajaID(resultSet.getString("OpcionCajaID"));
					impresionTicket.setDescripcion(resultSet.getString("Descripcion"));
					impresionTicket.setEsReversa(resultSet.getString("EsReversa"));
					impresionTicket.setImpTicketResumen(resultSet.getString("ImpTicketResumen"));
					impresionTicket.setCampoPantalla(resultSet.getString("CampoPantalla"));
					impresionTicket.setMostrarBtnResumen(resultSet.getString("MostrarBtnResumen"));
					return impresionTicket;
				}
			});

			impresionTicketResumenBeanResponse = matches.size() > 0 ? (ImpresionTicketResumenBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Impresión de Ticket Resumen ", exception);
			impresionTicketResumenBeanResponse = null;
		}

		return impresionTicketResumenBeanResponse;
	}
}
