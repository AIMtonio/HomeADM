package tesoreria.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import tesoreria.bean.BonificacionesBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BonificacionesDAO extends BaseDAO {


	public BonificacionesDAO(){
		super();
	}

	// Reporte de Bitacora por Documento
	public List<BonificacionesBean> reporteBonificaciones(final BonificacionesBean bonificacionesBean, final int tipoReporte) {

		List<BonificacionesBean> listaBonificaciones = null;
		//Query con el Store Procedure
		try{
			String query = "CALL BONIFICACIONESREP(?,?,?,?,"
												 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteFecha(bonificacionesBean.getFechaInicio()),
				Utileria.convierteFecha(bonificacionesBean.getFechaFin()),
				bonificacionesBean.getEstatus(),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"BonificacionesDAO.reporteBonificaciones",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL BONIFICACIONESREP(" + Arrays.toString(parametros) + ")");
			List<BonificacionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					BonificacionesBean  documentos = new BonificacionesBean();

					documentos.setBonificacionID(resultSet.getString("BonificacionID"));
					documentos.setClienteID(resultSet.getString("ClienteID"));
					documentos.setNombreCliente(resultSet.getString("NombreCliente"));
					documentos.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					documentos.setMonto(resultSet.getString("Monto"));

					documentos.setTipoDispersion(resultSet.getString("TipoDispersion"));
					documentos.setEstatus(resultSet.getString("Estatus"));
					documentos.setFolioDispersion(resultSet.getString("FolioDispersion"));
					documentos.setMeses(resultSet.getString("Meses"));
					documentos.setMontoAmortizado(resultSet.getString("MontoAmortizado"));

					documentos.setMontoPorAmortizar(resultSet.getString("MontoPorAmortizar"));
					return documentos;

				}
			});

			listaBonificaciones = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Bonificaciones ", exception);
			listaBonificaciones = null;
		}

		return listaBonificaciones;
	}

}
