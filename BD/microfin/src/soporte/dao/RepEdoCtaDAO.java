package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.RepEdoCtaBean;


public class RepEdoCtaDAO extends BaseDAO {
	/**
	 * Funcion para obtener los datos necesarios para generar el reporte de estado de cuenta.
	 * 
	 * @param numeroReporte: Numero de reporte 1.
	 * @param repEdoCtaBean: Bean con los datos necesarios para consultar los parametros.
	 * @return Lista de objetos RepEdoCtaBean.
	 * @author jcardenas
	 */
	public List<RepEdoCtaBean> reporteEdoCta(int numeroReporte, final RepEdoCtaBean repEdoCtaBean){
		List<RepEdoCtaBean> resultado = null;

		try {
			String query="CALL EDOCTAENVIOCORREOREP(	?,?,?,?,?,	?,?,?,?,?," +
														"?)";
			Object[] parametros={
					repEdoCtaBean.getAnioMes(),
					repEdoCtaBean.getClienteID(),
					repEdoCtaBean.getEstatus(),
					numeroReporte,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"RepEdoCtaDAO.reporteEdoCta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOREP("+ Arrays.toString(parametros)+")");
			List<RepEdoCtaBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					RepEdoCtaBean repEdoCtaBean = new RepEdoCtaBean();
					repEdoCtaBean.setAnioMes(resultSet.getString("AnioMes"));
					repEdoCtaBean.setClienteID(resultSet.getString("ClienteID"));
					repEdoCtaBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					repEdoCtaBean.setSucursalID(resultSet.getString("SucursalID"));
					repEdoCtaBean.setSucursal(resultSet.getString("NombreSucurs"));
					repEdoCtaBean.setPdfGenerado(resultSet.getString("PDFGenerado"));
					repEdoCtaBean.setEstatusEdoCta(resultSet.getString("EstatusEdoCta"));
					repEdoCtaBean.setEstatusEnvio(resultSet.getString("EstatusEnvio"));

					return repEdoCtaBean;
				}
			});
			resultado = matches.size() > 0 ? matches : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de reporte de pago de servicios", e);
		}
		return resultado;
	}
}
