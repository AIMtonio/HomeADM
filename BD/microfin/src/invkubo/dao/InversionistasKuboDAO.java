package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import invkubo.bean.FondeoSolicitudBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
 

public class InversionistasKuboDAO extends BaseDAO{

	/* Lista de Solicitudes de Fondeo */
	public List listaPrincipal(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call FONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { fondeoSolicitudBean.getSolicitudCreditoID(), tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(), 
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitudBean = new FondeoSolicitudBean();
				fondeoSolicitudBean.setFondeoKuboID(String.valueOf(resultSet.getInt(1)));
				fondeoSolicitudBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(2)));
				fondeoSolicitudBean.setConsecutivo(resultSet.getString(3));
				fondeoSolicitudBean.setFechaRegistro(resultSet.getString(4));
				fondeoSolicitudBean.setMontoFondeo(String.valueOf(resultSet.getInt(5)));
				fondeoSolicitudBean.setPorcentajeFondeo(resultSet.getString(6));
				fondeoSolicitudBean.setTasaActiva(resultSet.getString(7));
				fondeoSolicitudBean.setTasaPasiva(resultSet.getString(8));
				return fondeoSolicitudBean;
			}
		});

		return matches;
	}

	
}
